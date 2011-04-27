Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433Ab1D0NUP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 09:20:15 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42968 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759153Ab1D0NUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 09:20:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=I96PlK62CQF2Lg2ZZxzsFwhFRLq3eOKTcahRAdaJGJnvoHH4+NorgH5uhDI6BEpxjh
         DnO7lbiOGkjY/ppapUJiJmna/0u0uXfym2c/QX31hzz8cgIXaBIFjpMY+oV9UaamRAUc
         hGFSNK2tZxnQrmt9/M/yciHp8+NqEiSMxOiss=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org, arnd@arndb.de
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v3 0/7] remove CONFIG_GENERIC_FIND_{NEXT_BIT,BIT_LE,LAST_BIT}
Date: Wed, 27 Apr 2011 22:20:04 +0900
Message-Id: <1303910411-15793-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog v3:
- Add Acked-by: lines
- Make m68knommu build fix come first for 2.6.39 inclusion

Changelog v2:
- Add Acked-by: line
- Rebase to mainline

The style that we normally use in asm-generic is to test the macro itself
for existence, so in asm-generic, do:

	#ifndef find_next_zero_bit_le
	extern unsigned long find_next_zero_bit_le(const void *addr,
		unsigned long size, unsigned long offset);
	#endif

and in the architectures, write

	static inline unsigned long find_next_zero_bit_le(const void *addr,
		unsigned long size, unsigned long offset)
	#define find_next_zero_bit_le find_next_zero_bit_le

But CONFIG_GENERIC_FIND_{NEXT_BIT,BIT_LE,LAST_BIT} options are used to
test for existence of find bitops now.

This patch series switches find bitops to follow the normal style 
described above.  This change enables arm and s390 to use
asm-generic/bitops/le.h header file.

Akinobu Mita (7):
  m68knommu: fix build error due to the lack of find_next_bit_le()
  arch: add #define for each of optimized find bitops
  bitops: add #ifndef for each of find bitops
  arch: remove CONFIG_GENERIC_FIND_{NEXT_BIT,BIT_LE,LAST_BIT}
  arm: use asm-generic/bitops/le.h
  s390: use asm-generic/bitops/le.h
  m68knommu: use generic find_next_bit_le()

 arch/alpha/Kconfig                |    4 ---
 arch/arm/include/asm/bitops.h     |   46 ++++++------------------------------
 arch/avr32/include/asm/bitops.h   |   15 ++++++++++++
 arch/blackfin/Kconfig             |    3 --
 arch/cris/Kconfig                 |    4 ---
 arch/frv/Kconfig                  |    8 ------
 arch/h8300/Kconfig                |    8 ------
 arch/ia64/Kconfig                 |    4 ---
 arch/m32r/Kconfig                 |    8 ------
 arch/m68k/Kconfig.nommu           |    4 ---
 arch/m68k/include/asm/bitops_mm.h |    8 ++++++
 arch/m68k/include/asm/bitops_no.h |    4 +++
 arch/microblaze/Kconfig           |    6 -----
 arch/mips/Kconfig                 |    8 ------
 arch/mn10300/Kconfig              |    3 --
 arch/parisc/Kconfig               |    8 ------
 arch/powerpc/Kconfig              |    8 ------
 arch/s390/include/asm/bitops.h    |   45 ++++++++----------------------------
 arch/score/Kconfig                |    3 --
 arch/sh/Kconfig                   |    6 -----
 arch/sparc/Kconfig                |    8 ------
 arch/tile/Kconfig                 |    1 -
 arch/um/Kconfig.x86               |    1 -
 arch/x86/Kconfig                  |    1 -
 arch/xtensa/Kconfig               |    6 -----
 include/asm-generic/bitops/find.h |    4 +++
 include/asm-generic/bitops/le.h   |    7 +++++
 include/linux/bitops.h            |    4 +-
 lib/Kconfig                       |   10 --------
 lib/Makefile                      |    9 ++-----
 lib/find_last_bit.c               |    4 +++
 lib/find_next_bit.c               |   18 +++++++++-----
 32 files changed, 77 insertions(+), 199 deletions(-)

-- 
1.7.4.4

