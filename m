Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab2B0VAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 16:00:17 -0500
Received: from mail.windriver.com ([147.11.1.11]:56696 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610Ab2B0VAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 16:00:15 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: JBottomley@parallels.com, jejb@parisc-linux.org, kyle@mcmartin.ca,
        deller@gmx.de
Cc: vapier@gentoo.org, dave.anglin@bell.net, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH v2] parisc: dont unconditionally override CROSS_COMPILE for 64 bit.
Date: Mon, 27 Feb 2012 15:59:19 -0500
Message-Id: <1330376359-23731-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1330298813-17262-1-git-send-email-paul.gortmaker@windriver.com>
References: <1330298813-17262-1-git-send-email-paul.gortmaker@windriver.com>
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

Since you can set CROSS_COMPILE from the environment and/or set
it in your .config file, there really is no need for it to be
poked at by the Makefile at all.  So just delete it.

[1] ftp://ftp.kernel.org/pub/tools/crosstool/files/bin/x86_64/4.5.2/

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[v2: no ifdef/endif -- just delete the offending line.]

diff --git a/arch/parisc/Makefile b/arch/parisc/Makefile
index 55cca1d..a533367 100644
--- a/arch/parisc/Makefile
+++ b/arch/parisc/Makefile
@@ -31,7 +31,6 @@ ifdef CONFIG_64BIT
 UTS_MACHINE	:= parisc64
 CHECKFLAGS	+= -D__LP64__=1 -m64
 WIDTH		:= 64
-CROSS_COMPILE	:= hppa64-linux-gnu-
 else # 32-bit
 WIDTH		:=
 endif
-- 
1.7.9.1

