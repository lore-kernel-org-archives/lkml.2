Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab1CRE63 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 00:58:29 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:46739 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab1CRE6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 00:58:24 -0400
MIME-Version: 1.0
X-Originating-IP: [74.117.61.21]
Date: Fri, 18 Mar 2011 12:58:23 +0800
Message-ID: <AANLkTikuBxnd0bFsO5NP2GQYDZmGFP9kLruWVpjZ7+UQ@mail.gmail.com>
Subject: [PATCH] Fixup personality in different ABI.
From: Heiher <admin@heiher.info>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

>From bf3637153bc5e3d0e3f1c2982c323057a8e04801 Mon Sep 17 00:00:00 2001
From: Heiher <admin@heiher.info>
Date: Fri, 18 Mar 2011 12:51:08 +0800
Subject: [PATCH] Fixup personality in different ABI.

* 'arch' output:
	o32 : mips
	n32 : mips64
	64  : mips64
---
 arch/mips/include/asm/elf.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/mips/include/asm/elf.h b/arch/mips/include/asm/elf.h
index 455c0ac..01510d4 100644
--- a/arch/mips/include/asm/elf.h
+++ b/arch/mips/include/asm/elf.h
@@ -262,6 +262,7 @@ do {									\
 #ifdef CONFIG_MIPS32_N32
 #define __SET_PERSONALITY32_N32()					\
 	do {								\
+		set_personality(PER_LINUX);				\
 		set_thread_flag(TIF_32BIT_ADDR);			\
 		current->thread.abi = &mips_abi_n32;			\
 	} while (0)
@@ -273,6 +274,7 @@ do {									\
 #ifdef CONFIG_MIPS32_O32
 #define __SET_PERSONALITY32_O32()					\
 	do {								\
+		set_personality(PER_LINUX32);			\
 		set_thread_flag(TIF_32BIT_REGS);			\
 		set_thread_flag(TIF_32BIT_ADDR);			\
 		current->thread.abi = &mips_abi_32;			\
@@ -305,7 +307,10 @@ do {									\
 	if ((ex).e_ident[EI_CLASS] == ELFCLASS32)			\
 		__SET_PERSONALITY32(ex);				\
 	else								\
+	{								\
+		set_personality(PER_LINUX);				\
 		current->thread.abi = &mips_abi;			\
+	}								\
 									\
 	p = personality(current->personality);				\
 	if (p != PER_LINUX32 && p != PER_LINUX)				\
-- 
1.7.4.1.225.g83c3c

-- 
Best regards!
Heiher
