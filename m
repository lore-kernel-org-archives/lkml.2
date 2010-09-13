Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab0IMKrk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 06:47:40 -0400
Received: from mail.ddl.dyc.edu ([67.151.215.230]:36620 "EHLO ddl.dyc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353Ab0IMKrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 06:47:39 -0400
X-Greylist: delayed 1483 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Sep 2010 06:47:39 EDT
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] fix cc1 options to disable -fPIE when compiling with CONFIG_CC_STACKPROTECTOR=y
Message-Id: <20100913101319.748A1148E216@opensource.dyc.edu>
Date: Mon, 13 Sep 2010 06:13:19 -0400 (EDT)
From: basile@opensource.dyc.edu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The arch/x86/Makefile uses scripts/gcc-x86_$(BITS)-has-stack-protector.sh
to check if cc1 supports -fstack-protector.  When -fPIE is passed to cc1,
these scripts fail causing stack protection to be disabled even when it
is available.

This fix is similar to commit c47efe5548abbf53c2f66e06dcb46183b11d6b22

Reported-by: Kai Dietrich <mail@cleeus.de>
Signed-off-by: Magnus Granberg <zorry@gentoo.org>
Signed-off-by: Anthony G. Basile <basile@opensource.dyc.edu>
---
 arch/x86/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 8aa1b59..e8c8881 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -74,7 +74,7 @@ endif
 
 ifdef CONFIG_CC_STACKPROTECTOR
 	cc_has_sp := $(srctree)/scripts/gcc-x86_$(BITS)-has-stack-protector.sh
-        ifeq ($(shell $(CONFIG_SHELL) $(cc_has_sp) $(CC) $(biarch)),y)
+        ifeq ($(shell $(CONFIG_SHELL) $(cc_has_sp) $(CC) $(KBUILD_CPPFLAGS) $(biarch)),y)
                 stackp-y := -fstack-protector
                 KBUILD_CFLAGS += $(stackp-y)
         else
