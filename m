Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757850Ab1ANPY3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 10:24:29 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56816 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757680Ab1ANPYX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 10:24:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=vrfy.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Ap+4yXEAqS39PG/4PEoh60h4QstPXbsOkBIHf34v7P4bIKB5gGqyaP4KNEih77Qx6/
         nP3xr4vzSDcLONUvl1EZFSde1QtKfRg19Aaw4dZoSXzcUGQAdxNPaGrQF1qJCX4eUP9U
         JB/+WA1yFZ5PRx9Wr0sKxCkKlroEQMqYhtmiM=
MIME-Version: 1.0
In-Reply-To: <20110114150736.GJ16523@nb.net.home>
References: <20110113131216.GF30719@htj.dyndns.org> <20110113132637.GH16523@nb.net.home>
 <20110113133722.GG30719@htj.dyndns.org> <4D2F04FF.1070309@redhat.com>
 <20110113141107.GI30719@htj.dyndns.org> <4D2F0B6A.6010201@redhat.com>
 <AANLkTinJ68D6Yc-U-Q=ZfS9mqozj5qtHPtySZHOgjcgP@mail.gmail.com>
 <AANLkTi=LKYzrNsU7jc1Nr4W4CaQ_dmBGeQAquSCp_yAX@mail.gmail.com>
 <20110113155955.GI16523@nb.net.home> <AANLkTimXkF-JNaU12wLecdszMLZkfTh405tNabzEF4L_@mail.gmail.com>
 <20110114150736.GJ16523@nb.net.home>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 14 Jan 2011 16:23:56 +0100
Message-ID: <AANLkTin2WjO4aRbB+x01YxDjKSHF1oc2sJi==f+C7c_s@mail.gmail.com>
Subject: Re: [dm-devel] linux-next - WARNING: at fs/block_dev.c:824 bd_link_disk_holder+0x92/0x1ac()
To: Karel Zak <kzak@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Milan Broz <mbroz@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 16:07, Karel Zak <kzak@redhat.com> wrote:
> On Thu, Jan 13, 2011 at 05:10:02PM +0100, Kay Sievers wrote:
>> On Thu, Jan 13, 2011 at 16:59, Karel Zak <kzak@redhat.com> wrote:
>> > On Thu, Jan 13, 2011 at 03:43:38PM +0100, Kay Sievers wrote:
>> >> On Thu, Jan 13, 2011 at 15:30, Tejun Heo <tj@kernel.org> wrote:
>> >> > On Thu, Jan 13, 2011 at 3:25 PM, Milan Broz <mbroz@redhat.com> wrote:
>> >> >> Maybe, but this was not invented in DM/MD camp:-)
>> >> >> Probably Kay or Greg can answer why it was done this way?
>> >>
>> >> It's not from Greg or Kay. It just appeared some day in the context of dm. :)
>> >>
>> >> And yes, symlinks *look* nice and simple for the outside, but they are
>> >> not, and have all sorts of problems like non-atomic updates, make it
>> >
>> >  Sounds like sysfs implementation problem, right?
>>
>> It's a normal multi-file problem. It can by-definition not be atomic
>> without doing really weird locking things.
>
>  BTW, lsblk(8) and libblkid don't depend on the fact that slaves/holders
>  files are symlinks.
>
>  The important thing is the filename (/sys/block/.../slaves/<name>)
>  only. We don't follow the symlinks and we don't use readlink() there.
>
>  It means that you can replace the symlinks with regular files where
>  in the file contents is for example maj:min, etc.

I don't think we really can change anything here, there are more users of it.

If we would go changing things here, the file names should never be
the device name but the format "b8:32" for blockdevs, "n22" for the
network ifindex, ... which is the unchangeable unique kernel id -- not
depending on any possible device rename, or fast destroy/re-create or
anything like that.

Kay
