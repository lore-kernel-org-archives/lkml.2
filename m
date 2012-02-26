Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237Ab2BZRf0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 12:35:26 -0500
Received: from smtprelay02.ispgateway.de ([80.67.31.29]:52974 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab2BZRfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 12:35:25 -0500
From: Bernhard Walle <bernhard@bwalle.de>
To: mmarek@suse.cz
Cc: lacombar@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH] scripts/Kbuild.include: Fix portability problem of "echo -e"
Date: Sun, 26 Feb 2012 18:35:18 +0100
Message-Id: <1330277718-2667-1-git-send-email-bernhard@bwalle.de>
X-Mailer: git-send-email 1.7.9
X-Df-Sender: YmVybmhhcmRAYndhbGxlLmRl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"echo -e" is a GNU extension. When cross-compiling the kernel on a
BSD-like operating system (Mac OS X in my case), this doesn't work.

One could install a GNU version of echo, put that in the $PATH before
the system echo and use "/usr/bin/env echo", but the solution with
printf is simpler.

Since it is no disadvantage on Linux, I hope that gets accepted even if
cross-compiling the Linux kernel on another Unix operating system is
quite a rare use case.

Signed-off-by: Bernhard Walle <bernhard@bwalle.de>
---
 scripts/Kbuild.include |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index d897278..6a3ee98 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -104,7 +104,7 @@ as-option = $(call try-run,\
 # Usage: cflags-y += $(call as-instr,instr,option1,option2)
 
 as-instr = $(call try-run,\
-	/bin/echo -e "$(1)" | $(CC) $(KBUILD_AFLAGS) -c -xassembler -o "$$TMP" -,$(2),$(3))
+	printf "%b\n" "$(1)" | $(CC) $(KBUILD_AFLAGS) -c -xassembler -o "$$TMP" -,$(2),$(3))
 
 # cc-option
 # Usage: cflags-y += $(call cc-option,-march=winchip-c6,-march=i586)
-- 
1.7.9

