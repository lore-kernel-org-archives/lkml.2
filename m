Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175Ab0D0LcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 07:32:17 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:62913 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728Ab0D0LcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 07:32:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH 00/10] bkl: pushdowns from Arnd, and compile fixes
Date: Tue, 27 Apr 2010 13:31:57 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
References: <1272359898-32020-1-git-send-email-jkacur@redhat.com>
In-Reply-To: <1272359898-32020-1-git-send-email-jkacur@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201004271331.58130.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/WABsNEbvywTVBxR5/+PRjl3/jSolF9t+kLYd
 MNk62F56fYguVWtMqoNU3HK2AC/Pb+DJBlU8Rz+SkR8xGPDxBt
 +jYeD8szgdqG7gYjKhJxA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 April 2010, John Kacur wrote:
> These are bkl pushdowns from Arnd that conflicted with
> Linus's "Preparation for BKL'ed ioctl removal patch". I fixed-up the merge
> conflicts. In addition - during allyesconfig compile testing on x86_64 I found
> a number of issues that I fixed-up

Thanks for catching the scsi bugs! It was getting late yesterday night, so
I didn't go through a full allyesconfig then.

> I pushed these to my own new linus-bkl tree.
> git://www.kernel.org/pub/scm/linux/kernel/git/jkacur/jk-2.6.git linux-bkl
> 
> Frederic, if you want to grab those, pls do so. also, we might want to combine
> my compile fixes with Arnd's push-down patches, for better git bisectability.

Yes, your fixes (except the v4l2 patch, see comment there) should best be
merged into the main patches.

The idea was that if we manage to kill all fops->ioctl users right away,
we wouldn't even need Linus' patch and move to dungeon level 2 directly.
Either way works for me though.

Should we just split up the rest? If you, Frederic and me each take one
of these chunks, we're done. According to the diffstat from Linus' patch,
this is what's left:

a) arch specific drivers
 arch/cris/arch-v10/drivers/ds1302.c         |    2 +-
 arch/cris/arch-v10/drivers/gpio.c           |    2 +-
 arch/cris/arch-v10/drivers/i2c.c            |    2 +-
 arch/cris/arch-v10/drivers/pcf8563.c        |    2 +-
 arch/cris/arch-v10/drivers/sync_serial.c    |    2 +-
 arch/cris/arch-v32/drivers/cryptocop.c      |    2 +-
 arch/cris/arch-v32/drivers/i2c.c            |    2 +-
 arch/cris/arch-v32/drivers/mach-a3/gpio.c   |    2 +-
 arch/cris/arch-v32/drivers/mach-fs/gpio.c   |    2 +-
 arch/cris/arch-v32/drivers/pcf8563.c        |    2 +-
 arch/cris/arch-v32/drivers/sync_serial.c    |    2 +-
 arch/ia64/kernel/perfmon.c                  |    2 +-
 arch/ia64/sn/kernel/sn2/sn_hwperf.c         |    2 +-
 arch/m68k/bvme6000/rtc.c                    |    2 +-
 arch/m68k/mvme16x/rtc.c                     |    2 +-
 arch/um/drivers/harddog_kern.c              |    2 +-
 arch/um/drivers/hostaudio_kern.c            |    4 +-
 arch/um/drivers/mmapper_kern.c              |    2 +-

b) file systems (my other series has patches for some of these already)
 fs/autofs/root.c                            |    2 +-
 fs/autofs4/root.c                           |    2 +-
 fs/coda/pioctl.c                            |    2 +-
 fs/coda/psdev.c                             |    2 +-
 fs/fat/dir.c                                |    2 +-
 fs/fat/file.c                               |    2 +-
 fs/hfsplus/dir.c                            |    2 +-
 fs/hfsplus/inode.c                          |    2 +-
 fs/logfs/dir.c                              |    2 +-
 fs/logfs/file.c                             |    2 +-
 fs/ncpfs/dir.c                              |    2 +-
 fs/ncpfs/file.c                             |    2 +-
 fs/ntfs/dir.c                               |    2 +-
 fs/ntfs/file.c                              |    2 +-
 fs/smbfs/dir.c                              |    2 +-
 fs/smbfs/file.c                             |    2 +-
 fs/udf/dir.c                                |    2 +-
 fs/udf/file.c                               |    2 +-

c) special stuff (this should go last)
 Documentation/filesystems/vfs.txt           |    2 +-
 fs/bad_inode.c                              |    2 +-
 fs/ioctl.c                                  |    4 +-
 fs/compat_ioctl.c                           |    2 +-
 fs/ecryptfs/file.c                          |    9 ++++---
 fs/proc/inode.c                             |    8 +++---
 include/linux/fs.h                          |    2 -

	Arnd
