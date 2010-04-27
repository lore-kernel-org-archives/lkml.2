Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab0D0MUI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 08:20:08 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:58962 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab0D0MUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 08:20:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=HlaRZj9/f2oaGo/MdmMWBm9anWuo6yxdK24Z0oMdQkOtW21kP80ANDGHhFr4x+CvQI
         xUvU46ZufoG3QTPqeO4OPmGzuXwHDSvxDcwIythlmzlf02QMJTM2HE9bx4Yi0GaW4Fut
         psg2mS9kqOhiK3elvTUDCrZ9tZdWPNzWO8aBw=
Date: Tue, 27 Apr 2010 14:19:35 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost
To: Arnd Bergmann <arnd@arndb.de>
cc: John Kacur <jkacur@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 00/10] bkl: pushdowns from Arnd, and compile fixes
In-Reply-To: <201004271331.58130.arnd@arndb.de>
Message-ID: <alpine.LFD.2.00.1004271359180.3318@localhost>
References: <1272359898-32020-1-git-send-email-jkacur@redhat.com> <201004271331.58130.arnd@arndb.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 27 Apr 2010, Arnd Bergmann wrote:

> On Tuesday 27 April 2010, John Kacur wrote:
> > These are bkl pushdowns from Arnd that conflicted with
> > Linus's "Preparation for BKL'ed ioctl removal patch". I fixed-up the merge
> > conflicts. In addition - during allyesconfig compile testing on x86_64 I found
> > a number of issues that I fixed-up
> 
> Thanks for catching the scsi bugs! It was getting late yesterday night, so
> I didn't go through a full allyesconfig then.
> 
> > I pushed these to my own new linus-bkl tree.
> > git://www.kernel.org/pub/scm/linux/kernel/git/jkacur/jk-2.6.git linux-bkl
> > 
> > Frederic, if you want to grab those, pls do so. also, we might want to combine
> > my compile fixes with Arnd's push-down patches, for better git bisectability.
> 
> Yes, your fixes (except the v4l2 patch, see comment there) should best be
> merged into the main patches.
> 
> The idea was that if we manage to kill all fops->ioctl users right away,
> we wouldn't even need Linus' patch and move to dungeon level 2 directly.
> Either way works for me though.
> 
> Should we just split up the rest? If you, Frederic and me each take one
> of these chunks, we're done. According to the diffstat from Linus' patch,
> this is what's left:

Okay - good plan. I AM trying to balance doing my own day-to-day work,
and writing slides for a conference but I'm sure you and Frederic are
 just as pressed for time as me, so lets go-ahead and divide it up!
That will prevent us from doing redundant work.
I assume the target is 2.6.35 so, we have a little bit of time anyway.

I suggest we divide up a) and b) first and postone c) until the first
parts are done.

Arranging our names by alphabetical order and shuffling the files
off one at a time (for variety), I get this. Is everybody happy with that?
36 files / 3 = 12 files each.
Jan - speak up if you want in.

Arnd
----
arch/cris/arch-v10/drivers/ds1302.c
arch/cris/arch-v10/drivers/pcf8563.c
arch/cris/arch-v32/drivers/i2c.c
arch/cris/arch-v32/drivers/pcf8563.c
arch/ia64/sn/kernel/sn2/sn_hwperf.c
arch/m68k/mvme16x/rtc.c
arch/um/drivers/mmapper_kern.c
fs/coda/psdev.c
fs/hfsplus/dir.c
fs/logfs/file.c
fs/ntfs/dir.c
fs/smbfs/file.c

Frederic
--------
arch/cris/arch-v10/drivers/gpio.c
arch/cris/arch-v10/drivers/sync_serial.c
arch/cris/arch-v32/drivers/mach-a3/gpio.c
arch/cris/arch-v32/drivers/sync_serial.c
arch/m68k/bvme6000/rtc.c
arch/um/drivers/harddog_kern.c
fs/autofs/root.c
fs/fat/dir.c
fs/hfsplus/inode.c
fs/ncpfs/dir.c
fs/ntfs/file.c
fs/udf/dir.c

John
----
arch/cris/arch-v10/drivers/i2c.c
arch/cris/arch-v32/drivers/cryptocop.c
arch/cris/arch-v32/drivers/mach-fs/gpio.c
arch/ia64/kernel/perfmon.c
arch/m68k/bvme6000/rtc.c
arch/um/drivers/hostaudio_kern.c
fs/coda/pioctl.c
fs/fat/file.c
fs/logfs/dir.c
fs/ncpfs/file.c
fs/smbfs/dir.c
fs/udf/file.c

> 
> a) arch specific drivers
>  arch/cris/arch-v10/drivers/ds1302.c         |    2 +-
>  arch/cris/arch-v10/drivers/gpio.c           |    2 +-
>  arch/cris/arch-v10/drivers/i2c.c            |    2 +-
>  arch/cris/arch-v10/drivers/pcf8563.c        |    2 +-
>  arch/cris/arch-v10/drivers/sync_serial.c    |    2 +-
>  arch/cris/arch-v32/drivers/cryptocop.c      |    2 +-
>  arch/cris/arch-v32/drivers/i2c.c            |    2 +-
>  arch/cris/arch-v32/drivers/mach-a3/gpio.c   |    2 +-
>  arch/cris/arch-v32/drivers/mach-fs/gpio.c   |    2 +-
>  arch/cris/arch-v32/drivers/pcf8563.c        |    2 +-
>  arch/cris/arch-v32/drivers/sync_serial.c    |    2 +-
>  arch/ia64/kernel/perfmon.c                  |    2 +-
>  arch/ia64/sn/kernel/sn2/sn_hwperf.c         |    2 +-
>  arch/m68k/bvme6000/rtc.c                    |    2 +-
>  arch/m68k/mvme16x/rtc.c                     |    2 +-
>  arch/um/drivers/harddog_kern.c              |    2 +-
>  arch/um/drivers/hostaudio_kern.c            |    4 +-
>  arch/um/drivers/mmapper_kern.c              |    2 +-
> 
> b) file systems (my other series has patches for some of these already)
>  fs/autofs/root.c                            |    2 +-
>  fs/autofs4/root.c                           |    2 +-
>  fs/coda/pioctl.c                            |    2 +-
>  fs/coda/psdev.c                             |    2 +-
>  fs/fat/dir.c                                |    2 +-
>  fs/fat/file.c                               |    2 +-
>  fs/hfsplus/dir.c                            |    2 +-
>  fs/hfsplus/inode.c                          |    2 +-
>  fs/logfs/dir.c                              |    2 +-
>  fs/logfs/file.c                             |    2 +-
>  fs/ncpfs/dir.c                              |    2 +-
>  fs/ncpfs/file.c                             |    2 +-
>  fs/ntfs/dir.c                               |    2 +-
>  fs/ntfs/file.c                              |    2 +-
>  fs/smbfs/dir.c                              |    2 +-
>  fs/smbfs/file.c                             |    2 +-
>  fs/udf/dir.c                                |    2 +-
>  fs/udf/file.c                               |    2 +-
> 
> c) special stuff (this should go last)
>  Documentation/filesystems/vfs.txt           |    2 +-
>  fs/bad_inode.c                              |    2 +-
>  fs/ioctl.c                                  |    4 +-
>  fs/compat_ioctl.c                           |    2 +-
>  fs/ecryptfs/file.c                          |    9 ++++---
>  fs/proc/inode.c                             |    8 +++---
>  include/linux/fs.h                          |    2 -
> 
> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
