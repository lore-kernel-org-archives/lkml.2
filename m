Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522Ab0EFRjA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 13:39:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7732 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759371Ab0EFRiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 13:38:12 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
       ysato@users.sourceforge.jp, tony.luck@intel.com, dhowells@redhat.com,
       kyle@mcmartin.ca, benh@kernel.crashing.org, schwidefsky@de.ibm.com,
       jgarzik@pobox.com, hare@suse.de, felipe.balbi@nokia.com
Subject: [PATCH] removing redundant ifdefs
Date: Thu,  6 May 2010 19:36:04 +0200
Message-Id: <1273167377-14270-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

removing redundant ifdefs.

the pattern is

	#ifdef DEF1
	...
	#ifdef DEF1
	...
	#endif
	...
	#endif

and removing the inner ifdef.

I found them using script all over the kernel so
I haven't even compile-tested some of them.

I CCed all the related maintainers, sorry if I put
any wrong one.


wbr,
jirka
---
 arch/arm/include/asm/processor.h              |    2 --
 arch/arm/mach-ixp23xx/include/mach/platform.h |    3 ---
 arch/arm/plat-omap/include/plat/clock.h       |    5 -----
 arch/h8300/include/asm/tlb.h                  |   13 -------------
 arch/ia64/include/asm/mmzone.h                |    4 ----
 arch/mn10300/include/asm/pgtable.h            |    4 ----
 arch/parisc/kernel/unaligned.c                |    2 --
 arch/powerpc/include/asm/vdso_datapage.h      |    2 --
 arch/powerpc/kernel/traps.c                   |    2 --
 arch/s390/include/asm/processor.h             |    5 -----
 arch/s390/kernel/vdso.c                       |    4 ----
 arch/x86/kernel/early-quirks.c                |    2 --
 drivers/ata/ahci.c                            |    2 --
 drivers/scsi/aic7xxx_old.c                    |    2 --
 drivers/usb/musb/musb_core.h                  |    9 ---------
 drivers/video/atafb.c                         |    2 --
 drivers/video/matrox/matroxfb_DAC1064.c       |    5 +----
 fs/ext4/super.c                               |    2 --
 include/linux/socket.h                        |    4 ----
 kernel/sched.c                                |    6 ------
 kernel/srcu.c                                 |    2 --
 security/capability.c                         |    2 --
 sound/pci/au88x0/au88x0_core.c                |    4 ----
 23 files changed, 1 insertions(+), 87 deletions(-)
