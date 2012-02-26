Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab2BZX1H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 18:27:07 -0500
Received: from mail.windriver.com ([147.11.1.11]:63177 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab2BZX1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 18:27:05 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: JBottomley@parallels.com, jejb@parisc-linux.org, kyle@mcmartin.ca,
        deller@gmx.de
Cc: linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH] parisc: dont unconditionally override CROSS_COMPILE for 64 bit.
Date: Sun, 26 Feb 2012 18:26:53 -0500
Message-Id: <1330298813-17262-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the 64 bit toolchains from kernel.org[1], one finds that
you can't build the a500_defconfig, because the Makefile will
stomp whatever value you have in your env. for CROSS_COMPILE.

This shows up since the kernel.org toolchains for parisc-64
do not have the "-gnu" prefix, and so you run into it always
saying hppa64-linux-gnu-gcc not found, regardless of the fact
you've not got "-gnu" put anywhere into CROSS_COMPILE.

[1] ftp://ftp.kernel.org/pub/tools/crosstool/files/bin/x86_64/4.5.2/

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/arch/parisc/Makefile b/arch/parisc/Makefile
index 55cca1d..cefff6d 100644
--- a/arch/parisc/Makefile
+++ b/arch/parisc/Makefile
@@ -31,7 +31,9 @@ ifdef CONFIG_64BIT
 UTS_MACHINE	:= parisc64
 CHECKFLAGS	+= -D__LP64__=1 -m64
 WIDTH		:= 64
-CROSS_COMPILE	:= hppa64-linux-gnu-
+ifndef CROSS_COMPILE
+ CROSS_COMPILE	:= hppa64-linux-gnu-
+endif
 else # 32-bit
 WIDTH		:=
 endif
-- 
1.7.9.1

