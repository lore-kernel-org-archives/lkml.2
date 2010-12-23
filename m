Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab0LWOlP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 09:41:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753048Ab0LWOlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 09:41:14 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Cc: Greg Freemyer <greg.freemyer@gmail.com>,
        Bruno =?utf-8?Q?Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Slow disks.
References: <20101220141553.GA6088@bitwizard.nl>
	<20101220190630.66084e1d@neptune.home>
	<AANLkTi=VAJbVSzX_DH9_==a3RonLJmawYu3MzF-uqGXC@mail.gmail.com>
	<20101222104306.GB30941@bitwizard.nl>
	<x49aajxsrh3.fsf@segfault.boston.devel.redhat.com>
	<20101222224416.GE30941@bitwizard.nl>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 23 Dec 2010 09:40:54 -0500
In-Reply-To: <20101222224416.GE30941@bitwizard.nl> (Rogier Wolff's message of
	"Wed, 22 Dec 2010 23:44:16 +0100")
Message-ID: <x494oa48scp.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rogier Wolff <R.E.Wolff@BitWizard.nl> writes:

> On Wed, Dec 22, 2010 at 11:27:20AM -0500, Jeff Moyer wrote:
>> Rogier Wolff <R.E.Wolff@BitWizard.nl> writes:
>> 
>> > Unquoted text below is from either me or from my friend. 
>> >
>> >
>> > Someone suggested we try an older kernel as if kernel 2.6.32 would not
>> > have this problem. We do NOT think it suddenly started with a certain
>> > kernel version. I was just hoping to have you kernel-guys help with
>> > prodding the kernel into revealing which component was screwing things
>> > up....
>> [...]
>> > ata3.00: ATA-8: WDC WD10EARS-00Y5B1, 80.00A80, max UDMA/133
>> 
>> This is an "Advanced format" drive, which, in this case, means it
>> internally has a 4KB sector size and exports a 512byte logical sector
>> size.  If your partitions are misaligned, this can cause performance
>> problems.
>
> This would mean that for a misalgned write, the drive would have to
> read-modify-write every super-sector. 
>
> In my performance calculations, 10ms average seek (should be around
> 7), 4ms average rotational latency for a total of 14ms. This would
> degrade for read-modify-write to 10+4+8 = 22ms. Still 10 times better
> than what we observe: service times on the order of 200-300ms. 

I didn't say it would account for all of your degradation, just that it
could affect performance.  I'm sorry if I wasn't clear on that.

>  > md1 : active raid5 sda2[0] sdd2[3](S) sdb2[1] sdc2[4]
>> >       39067648 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3]
>> > [UUU]
>> 
>> A 512KB raid5 chunk with 4KB I/Os?  That is a recipe for inefficiency.
>> Again, blktrace data would be helpful.
>
> Where did you get the 4kb IOs from? You mean from the iostat -x
> output?

Yes, since that's all I have to go on at the moment.

> The system/filesystem decided to do those small IOs. With the
> throughput we're getting on the filesystem, it better not try to write
> larger chuncks...

Your logic is a bit flawed, for so many reasons I'm not even going to
try to enumerate them here.  Anyway, I'll continue to sound like a
broken record and ask for blktrace data.

> I have benchmarked my own "high bandwidth" raid arrays. I benchmarked
> them with 128k, 256, 512 and 1024k blocksize. I got the best
> throughput (for my benchmark: dd if=/dev/md0 of=/dev/null bs=1024k)
> with 512k blocksize. (and yes that IS a valid benchmark for my
> usage of the array.)

Sorry, I'm not sure I understand how this is relevant.  I thought we
were troubleshooting a problem on someone else's system.  Further, the
window into the workload we saw via iostat definitely shows that smaller
I/Os are issued.

Anyway, it will be much easier to debate the issue once the blktrace
data is gathered.

Happy holidays.

-Jeff
