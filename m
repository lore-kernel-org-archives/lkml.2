Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838Ab1DOM32 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 08:29:28 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52388 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab1DOM31 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 08:29:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=szeredi.hu; s=google;
        h=mime-version:x-originating-ip:in-reply-to:references:date
         :message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=NAbCXYLQgo+OBSS1JtJ7Hs1aJ1oLK7iVvwdfdvsjY/0/jeiE8E/4eUkqW/bfXd0OjX
         Ub9Ae37x5Yu0XQlysHL/X2xUIInw3BrBDFcc78Cg1Ume/xs9xiEzkx9Nv8Hlo62IvXLo
         cGw7afgtQqvfpMHsgmV0b9VRUWiAxFn1laJKE=
MIME-Version: 1.0
X-Originating-IP: [88.209.222.127]
In-Reply-To: <BANLkTikTUo17RncV7bushPTri=LEykep5g@mail.gmail.com>
References: <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com>
	<4DA4B6A8.7030804@gmail.com>
	<BANLkTimsAE1ZAJhsSjnh3LqwsN9x0cLaXg@mail.gmail.com>
	<alpine.LRH.2.00.1104131618170.6953@twin.jikos.cz>
	<BANLkTindBULU9KAVWPJQ7oQvfCNQU-BuAg@mail.gmail.com>
	<BANLkTin6CVFOAECWwYg3B5V2AfscFfjt8w@mail.gmail.com>
	<BANLkTik7jasnvqFQohRdU-3crM8fr9pBXg@mail.gmail.com>
	<BANLkTikF_hgYSaZJbZosWwcs715tLXYfmQ@mail.gmail.com>
	<BANLkTikTUo17RncV7bushPTri=LEykep5g@mail.gmail.com>
Date: Fri, 15 Apr 2011 14:29:25 +0200
Message-ID: <BANLkTikUe_2Uo2_tSYdfNoNXKYO4Bj30iQ@mail.gmail.com>
Subject: Re: Unionmount status?
From: Miklos Szeredi <miklos@szeredi.hu>
To: Michal Suchanek <hramrach@centrum.cz>
Cc: Jiri Kosina <jkosina@suse.cz>, Ric Wheeler <ricwheeler@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Ian Kent <ikent@redhat.com>,
        Jeff Moyer <jmoyer@redhat.com>, Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 15, 2011 at 1:51 PM, Michal Suchanek <hramrach@centrum.cz> wrote:
> On 15 April 2011 13:31, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Fri, Apr 15, 2011 at 1:22 PM, Michal Suchanek <hramrach@centrum.cz> wrote:
>>>
>>> Cleaning up temporary files...
>>> [    nn.nnnnnn] overlayfs: ERROR - failed to whiteout 'motd'
>>> find: cannot delete `./motd': Operation not supported
>>
>> What is the upper filesystem type?  Is xattr support enabled?
>>
>
> The upper filesystem is tmpfs and there is not option regarding XATTR
> in the config.

Apparently tmpfs does not support generic xattr.  I understand why
tmpfs is an attractive choice for an upper filesystem, so this should
be addressed.

I see two options here:

1) implement generic xattr in tmpfs
2) take whiteout/opaque support from union mounts and use that

Both have advantages and disadvantages.

Any thoughts?

Thanks,
Miklos
