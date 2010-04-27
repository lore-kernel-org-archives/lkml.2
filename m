Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab0D0Mlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 08:41:39 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:40330 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab0D0Mlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 08:41:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=WSFikMdnm6+JQCgB8UOcHAs4AuYjfvIqcWNTJHkWrGkn005jyxATBOHfqajrIOy7SS
         OxniaAGjBl7CgZqAh3kJtpfcFUBWgBPpIENapiLS5D26x1fZjOtBpHhCqJ13APLyYvle
         qkB8gOL2+PKI6FDEnvtUtKj9PQYQABtJgTINs=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1004271359180.3318@localhost>
References: <1272359898-32020-1-git-send-email-jkacur@redhat.com>
	 <201004271331.58130.arnd@arndb.de>
	 <alpine.LFD.2.00.1004271359180.3318@localhost>
Date: Tue, 27 Apr 2010 14:41:35 +0200
Message-ID: <m2xc62985531004270541n6537bc9bj1936319952a9f4ca@mail.gmail.com>
Subject: Re: [PATCH 00/10] bkl: pushdowns from Arnd, and compile fixes
From: Frederic Weisbecker <fweisbec@gmail.com>
To: John Kacur <jkacur@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/4/27 John Kacur <jkacur@redhat.com>:
>
>
> On Tue, 27 Apr 2010, Arnd Bergmann wrote:
>
>> On Tuesday 27 April 2010, John Kacur wrote:
>> > These are bkl pushdowns from Arnd that conflicted with
>> > Linus's "Preparation for BKL'ed ioctl removal patch". I fixed-up the merge
>> > conflicts. In addition - during allyesconfig compile testing on x86_64 I found
>> > a number of issues that I fixed-up
>>
>> Thanks for catching the scsi bugs! It was getting late yesterday night, so
>> I didn't go through a full allyesconfig then.
>>
>> > I pushed these to my own new linus-bkl tree.
>> > git://www.kernel.org/pub/scm/linux/kernel/git/jkacur/jk-2.6.git linux-bkl
>> >
>> > Frederic, if you want to grab those, pls do so. also, we might want to combine
>> > my compile fixes with Arnd's push-down patches, for better git bisectability.
>>
>> Yes, your fixes (except the v4l2 patch, see comment there) should best be
>> merged into the main patches.
>>
>> The idea was that if we manage to kill all fops->ioctl users right away,
>> we wouldn't even need Linus' patch and move to dungeon level 2 directly.
>> Either way works for me though.
>>
>> Should we just split up the rest? If you, Frederic and me each take one
>> of these chunks, we're done. According to the diffstat from Linus' patch,
>> this is what's left:
>
> Okay - good plan. I AM trying to balance doing my own day-to-day work,
> and writing slides for a conference but I'm sure you and Frederic are
>  just as pressed for time as me, so lets go-ahead and divide it up!
> That will prevent us from doing redundant work.
> I assume the target is 2.6.35 so, we have a little bit of time anyway.
>
> I suggest we divide up a) and b) first and postone c) until the first
> parts are done.
>
> Arranging our names by alphabetical order and shuffling the files
> off one at a time (for variety), I get this. Is everybody happy with that?
> 36 files / 3 = 12 files each.
> Jan - speak up if you want in.
>
> Arnd
> ----
> arch/cris/arch-v10/drivers/ds1302.c
> arch/cris/arch-v10/drivers/pcf8563.c
> arch/cris/arch-v32/drivers/i2c.c
> arch/cris/arch-v32/drivers/pcf8563.c
> arch/ia64/sn/kernel/sn2/sn_hwperf.c
> arch/m68k/mvme16x/rtc.c
> arch/um/drivers/mmapper_kern.c
> fs/coda/psdev.c
> fs/hfsplus/dir.c
> fs/logfs/file.c
> fs/ntfs/dir.c
> fs/smbfs/file.c
>
> Frederic
> --------
> arch/cris/arch-v10/drivers/gpio.c
> arch/cris/arch-v10/drivers/sync_serial.c
> arch/cris/arch-v32/drivers/mach-a3/gpio.c
> arch/cris/arch-v32/drivers/sync_serial.c
> arch/m68k/bvme6000/rtc.c
> arch/um/drivers/harddog_kern.c
> fs/autofs/root.c
> fs/fat/dir.c
> fs/hfsplus/inode.c
> fs/ncpfs/dir.c
> fs/ntfs/file.c
> fs/udf/dir.c



Ok :)
