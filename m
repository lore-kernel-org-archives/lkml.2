Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977Ab1FOUbo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 16:31:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40775 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754749Ab1FOUbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 16:31:43 -0400
From: Michal Marek <mmarek@suse.cz>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] kbuild: Call depmod.sh via shell
Date: Wed, 15 Jun 2011 22:31:29 +0200
Message-Id: <1308169889-16835-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <4DF6EE1C.9090803@suse.cz>
References: <4DF6EE1C.9090803@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The script has the executable bit in git, but plain old patch(1) can't
create executable files.

Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 Makefile |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 4350937..6764063 100644
--- a/Makefile
+++ b/Makefile
@@ -1526,7 +1526,8 @@ quiet_cmd_rmfiles = $(if $(wildcard $(rm-files)),CLEAN   $(wildcard $(rm-files))
 
 # Run depmod only if we have System.map and depmod is executable
 quiet_cmd_depmod = DEPMOD  $(KERNELRELEASE)
-      cmd_depmod = $(srctree)/scripts/depmod.sh $(DEPMOD) $(KERNELRELEASE)
+      cmd_depmod = $(CONFIG_SHELL) $(srctree)/scripts/depmod.sh $(DEPMOD) \
+                   $(KERNELRELEASE)
 
 # Create temporary dir for module support files
 # clean it up only when building all modules
-- 
1.7.4.2

