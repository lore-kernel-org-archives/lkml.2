Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab1EGPyp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 11:54:45 -0400
Received: from diomedes.noc.ntua.gr ([147.102.222.220]:59380 "EHLO
	diomedes.noc.ntua.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459Ab1EGPyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 11:54:44 -0400
From: Stratos Psomadakis <psomas@cslab.ece.ntua.gr>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, schwab@linux-m68k.org
Subject: [RESEND PATCH 1/2] ppc: Fix compiler warning in ptrace.c [-Wno-array-bounds]
Date: Sat,  7 May 2011 18:54:34 +0300
Message-Id: <1304783674-3977-1-git-send-email-psomas@cslab.ece.ntua.gr>
X-Mailer: git-send-email 1.7.5.rc3
In-Reply-To: <m2oc3eh744.fsf@igel.home>
References: <m2oc3eh744.fsf@igel.home>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (diomedes.noc.ntua.gr [147.102.222.220]); Sat, 07 May 2011 18:54:37 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The trick used to bypass the thread_struct fpr array in order to access the
struct fpscr, in arch/powerpc/kernel/ptrace.c, can trigger an "array subscript
is above array bounds [-Werror=array-bounds]" warning.

Add -Wno-array-bounds to CFLAGS_ptrace.o, in arch/powerpc/kernel/Makefile to
slience this warning.

Signed-off-by: Stratos Psomadakis <psomas@ece.ntua.gr>
---
 arch/powerpc/kernel/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index 3bb2a3e..92b1002 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the linux kernel.
 #
 
-CFLAGS_ptrace.o		+= -DUTS_MACHINE='"$(UTS_MACHINE)"'
+CFLAGS_ptrace.o		+= -DUTS_MACHINE='"$(UTS_MACHINE)"' $(call cc-option, -Wno-array-bounds)
 
 subdir-ccflags-$(CONFIG_PPC_WERROR) := -Werror
 
-- 
1.5.6.5

