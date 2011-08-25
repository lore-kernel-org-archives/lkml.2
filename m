Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab1HYBDk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 21:03:40 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:64661 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab1HYBDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 21:03:39 -0400
From: Arnaud Lacombe <lacombar@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH] Kbuild: append missing-syscalls to the default target list
Date: Wed, 24 Aug 2011 21:03:30 -0400
Message-Id: <1314234210-11090-1-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.6.153.g78432
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This avoid an extra make invocation on `prepare0'.

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 Kbuild   |    4 +++-
 Makefile |    1 -
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/Kbuild b/Kbuild
index 2114113..1a2eb32 100644
--- a/Kbuild
+++ b/Kbuild
@@ -88,10 +88,12 @@ $(obj)/$(offsets-file): arch/$(SRCARCH)/kernel/asm-offsets.s Kbuild
 # 3) Check for missing system calls
 #
 
+always += missing-syscalls
+targets += missing-syscalls
+
 quiet_cmd_syscalls = CALL    $<
       cmd_syscalls = $(CONFIG_SHELL) $< $(CC) $(c_flags)
 
-PHONY += missing-syscalls
 missing-syscalls: scripts/checksyscalls.sh FORCE
 	$(call cmd,syscalls)
 
diff --git a/Makefile b/Makefile
index 0f1db8d..8e00684 100644
--- a/Makefile
+++ b/Makefile
@@ -983,7 +983,6 @@ archprepare: prepare1 scripts_basic
 
 prepare0: archprepare FORCE
 	$(Q)$(MAKE) $(build)=.
-	$(Q)$(MAKE) $(build)=. missing-syscalls
 
 # All the preparing..
 prepare: prepare0
-- 
1.7.6.153.g78432

