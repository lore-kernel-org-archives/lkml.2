Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab0LZXi4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 18:38:56 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55658 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588Ab0LZXix convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 18:38:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cgWVufVV+Iy3aB1aaOVTmfpXfdKwbZnkkYZHKvSLOs+z0URruHuHVJRYQkitQJ7Pj/
         QY4txBdsjnMrg3Kbztw/PrH9ShX0H4O3ParkRGfI8LEPyWzo02jouT7cZoFF0KWGyM5d
         SUnjGu5UZeD69TLknmQH3Qu7y9M20tNl+1WAU=
MIME-Version: 1.0
In-Reply-To: <x49aajxsrh3.fsf@segfault.boston.devel.redhat.com>
References: <20101220141553.GA6088@bitwizard.nl>
	<20101220190630.66084e1d@neptune.home>
	<AANLkTi=VAJbVSzX_DH9_==a3RonLJmawYu3MzF-uqGXC@mail.gmail.com>
	<20101222104306.GB30941@bitwizard.nl>
	<x49aajxsrh3.fsf@segfault.boston.devel.redhat.com>
Date: Sun, 26 Dec 2010 15:38:51 -0800
Message-ID: <AANLkTi=qAGCFU0u8joKVR4o4QQaRZt1XWfOPSt8eiD3r@mail.gmail.com>
Subject: Re: Slow disks.
From: Mark Knecht <markknecht@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Rogier Wolff <R.E.Wolff@bitwizard.nl>,
        Greg Freemyer <greg.freemyer@gmail.com>,
        =?UTF-8?Q?Bruno_Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 8:27 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Rogier Wolff <R.E.Wolff@BitWizard.nl> writes:
>
>> Unquoted text below is from either me or from my friend.
>>
>>
>> Someone suggested we try an older kernel as if kernel 2.6.32 would not
>> have this problem. We do NOT think it suddenly started with a certain
>> kernel version. I was just hoping to have you kernel-guys help with
>> prodding the kernel into revealing which component was screwing things
>> up....
> [...]
>> ata3.00: ATA-8: WDC WD10EARS-00Y5B1, 80.00A80, max UDMA/133
>
> This is an "Advanced format" drive, which, in this case, means it
> internally has a 4KB sector size and exports a 512byte logical sector
> size.  If your partitions are misaligned, this can cause performance
> problems.
>
>> MDstat:
>>
>> Personalities : [raid1] [raid6] [raid5] [raid4]
>> md125 : active raid5 sdd3[5](S) sdb3[4] sda3[0] sdc3[3]
>>       3903488 blocks super 1.1 level 5, 512k chunk, algorithm 2 [3/3] [UUU]
>>
>> md126 : active raid5 sda4[0] sdd4[3] sdc4[5](S) sdb4[4]
>>       1910063104 blocks super 1.1 level 5, 512k chunk, algorithm 2
>> [3/3] [UUU]
>>
>> md1 : active raid5 sda2[0] sdd2[3](S) sdb2[1] sdc2[4]
>>       39067648 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3]
>> [3/3] [UUU]
>>
>> md1 : active raid5 sda2[0] sdd2[3](S) sdb2[1] sdc2[4]
>>       39067648 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3]
>> [UUU]
>
> A 512KB raid5 chunk with 4KB I/Os?  That is a recipe for inefficiency.
> Again, blktrace data would be helpful.
>
> Cheers,
> Jeff

I am late to this thread but I'd like to give a +1 to everything Jeff said.

I tried to build many different mdadm RAID configurations using the
WD10EARS. They simply didn't work. There were huge delays and mdadm
would take drives off line. It was a mess.

First, the drives are 4K sector so it's really important to get them
on the right partition boundary. Installing Gentoo requires that we
un-tar some large-ish files. IIRC on a 512 byte boundary these drives
took 20-30 minutes to do this. On a 4K boundary they took about 1
minute. I know that doesn't make sense but those were my numbers, and
it's a very high end Intel i7-980x MB so there wasn't any other
problem I could find.

Even when I got that part worked out I found that the drives just
didn't work well in a RAID. The mdadm list led me to believe that the
root cause was the lack of TLER in the firmware. I don't know how to
show that's true or not...

When all that was determined I dropped RAID and I still ran into Load
Count issue that's discussed elsewhere in this thread.

I then bought 5 WD RAID Edition drives and everything works perfectly.
> 100MB/Sec on RAID1 and about 180MB/S on RAID0.

Overall the WD10EARS drives were very disappointing, at least as
shipped. I have 5 of them sitting here unused. I would like to find
some time to try them again one of these days but I don't have high
hopes.

Cheers,
Mark
