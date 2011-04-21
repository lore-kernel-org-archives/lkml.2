Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399Ab1DUPnt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 11:43:49 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:63408 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720Ab1DUPns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 11:43:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=ELVbbXh4KuE7Q5WSxnxNe++2geYuPC6fdGz4PPaKpYl8zJFX0O3JpOUZWf+qdQUod+
         4riJ3hxJMCUaysV4V79NCkS8+UEi/Wb02/M7QaExKpRYqGbQQrz9SQMy0JPN3opVgk5f
         QGcEn+sTPXqTyx+vX4jqvAfuPMdPtM1IGQiHA=
MIME-Version: 1.0
In-Reply-To: <BANLkTimPN-9dmZKU25oLmUjtGQYDsyCvgw@mail.gmail.com>
References: <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com>
 <871v0wvuod.fsf@tucsk.pomaz.szeredi.hu> <BANLkTikv+iCVgG_cgejqJjuS0xURrAvQuw@mail.gmail.com>
 <201104211658.35618.jordipujolp@gmail.com> <BANLkTimPN-9dmZKU25oLmUjtGQYDsyCvgw@mail.gmail.com>
From: Michal Suchanek <hramrach@centrum.cz>
Date: Thu, 21 Apr 2011 17:43:27 +0200
X-Google-Sender-Auth: tSfx8gLQI9SI4-KQf9XmLLS9GRE
Message-ID: <BANLkTi=HER-HDjLpu8Hw4fCMUwE7ii54_g@mail.gmail.com>
Subject: Re: [PATCH] tmpfs: implement generic xattr support
To: Jordi Pujol <jordipujolp@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        Phillip Lougher <phillip.lougher@gmail.com>,
        Andreas Dilger <adilger@dilger.ca>, Jiri Kosina <jkosina@suse.cz>,
        Ric Wheeler <ricwheeler@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Ian Kent <ikent@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, Hugh Dickins <hughd@google.com>,
        Eric Paris <eparis@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 April 2011 17:22, Michal Suchanek <hramrach@centrum.cz> wrote:
> On 21 April 2011 16:58, Jordi Pujol <jordipujolp@gmail.com> wrote:
>> A Dijous 21 Abril 2011 12:59:01, Michal Suchanek va escriure:
>>> Now it's time to build a larger image I guess.
>>
>> Hello,
>>
>> I have done it, building a desktop image that contains kde4 and some services,
>> The tests show that tmpfs is broken, it makes first operations but at some
>> point it becomes erratic; that occurs in non-persistent mode, where
>> overlayfs upperdir is on tmpfs, and in persistent mode also but in this case
>> more user working is needed before tmpfs failure,
>>
>> in Linux single user mode I have installed the nvidia packages and driver
>> using dpkg, only some files are installed, therefore I tried creating manually
>> a required directory and in this manner the process has done some steps more.
>>
>> kernel source:
>>
>> http://livenet.selfip.com/ftp/debian/linux-2.6/linux-2.6.38-3.jpp.3-
>> lnet_2.6.38-15.tar.bz2
>>
>> logs:
>>
>> http://livenet.selfip.com/ftp/debian/overlayfs/test-tmpfs-xattrs.tar.bz2
>>
>
> Yes, while the system appears to run generally fine unpacking dpkg
> packages fails.

You will be probably interested in this log:

ls: cannot access /usr/share/doc/ucb*: No such file or directory
...
rmdir("/usr/share/doc/ucblogo.dpkg-new") = -1 ENOENT (No such file or directory)
rmdir("/usr/share/doc/ucblogo.dpkg-tmp") = -1 ENOENT (No such file or directory)
mkdir("/usr/share/doc/ucblogo.dpkg-new", 0) = 0
chown32("/usr/share/doc/ucblogo.dpkg-new", 0, 0) = 0
chmod("/usr/share/doc/ucblogo.dpkg-new", 0755) = 0
utime("/usr/share/doc/ucblogo.dpkg-new", [2011/04/21-15:37:05,
2008/06/08-11:38:17]) = 0
rename("/usr/share/doc/ucblogo.dpkg-new", "/usr/share/doc/ucblogo") =
-1 EOPNOTSUPP (Operation not supported)

Thanks

Michal
