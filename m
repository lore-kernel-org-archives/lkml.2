Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466Ab2KPIxg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 03:53:36 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:41384 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab2KPIxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 03:53:35 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 0/9] x86, boot, 64bit: Add support for loading ramdisk and bzImage high
Date: Fri, 16 Nov 2012 00:53:00 -0800
Message-Id: <1353055989-31939-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we have limit kdump reseved under 896M, because kexec has the limitation.
and also bzImage need to stay under 4g.

To make kexec/kdump could use range above 4g, we need to make bzImage and
ramdisk could be loaded above 4g.
During booting bzImage will be unpacked on same postion and stay high.

The patches add field in boot header to
1. get info about ramdisk position info above 4g from bootloader/kexec
2. set code64_start_offset in header for bzImage and bootloader/kexec load
   could check that to decide if need to put bzImage high.

This patches is tested with kexec tools with local changes, will send kexec
tools change to kexec list later.

could be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-x86-boot

and it is on top of for-x86-mm

Thanks

Yinghai

Yinghai Lu (9):
  x86, boot: Move lldt/ltr out of 64bit only path
  x86: Add macro for 64bit entry for bzImage
  x86, 64bit: set extra ident page table for whole kernel range
  x86, 64bit: add support for loading kernel above 512G
  x86: Merge early_reserve_initrd for 32bit and 64bit
  x86: add get_ramdisk_image/size
  x86, boot: add field to support load bzImage and ramdisk high
  x86: ramdisk info print with high bits.
  x86: remove 1024g limitation for kexec buffer on 64bit

 Documentation/x86/boot.txt         |    4 ++
 arch/x86/boot/compressed/head_64.S |   11 ++++--
 arch/x86/boot/header.S             |   11 ++++++-
 arch/x86/include/asm/boot.h        |    2 +
 arch/x86/include/asm/bootparam.h   |    3 ++
 arch/x86/include/asm/kexec.h       |    6 ++--
 arch/x86/kernel/head32.c           |   11 ------
 arch/x86/kernel/head64.c           |   11 ------
 arch/x86/kernel/head_64.S          |   45 ++++++++++++++++++++++-----
 arch/x86/kernel/setup.c            |   61 +++++++++++++++++++++++++++--------
 10 files changed, 113 insertions(+), 52 deletions(-)

-- 
1.7.7

