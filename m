Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab0F1DBR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 23:01:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755897Ab0F1DBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 23:01:15 -0400
Date: Sun, 27 Jun 2010 23:01:06 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, David Rientjes <rientjes@google.com>,
       Michal Marek <mmarek@suse.cz>, Amerigo Wang <amwang@redhat.com>
Message-Id: <20100628030516.5187.49089.sendpatchset@localhost.localdomain>
In-Reply-To: <20100628030507.5187.95903.sendpatchset@localhost.localdomain>
References: <20100628030507.5187.95903.sendpatchset@localhost.localdomain>
Subject: [PATCH 2/2] Makefile: "make kernelrelease" should show the correct full kernel version
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amerigo Wang <amwang@redhat.com>
Date: Mon, 28 Jun 2010 10:45:21 +0800

After commit 85a256d8e0116c8f5ad276730830f5d4d473344d, 'make kernelrelease' doesn't
show the correct full kernel version. This patch fixes it, 'make kernelrelease' will
show the same version name with the one you finally get.

Cc: David Rientjes <rientjes@google.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Amerigo Wang <amwang@redhat.com>
---
 Makefile |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 710f91c..2b517a1 100644
--- a/Makefile
+++ b/Makefile
@@ -414,7 +414,7 @@ endif
 no-dot-config-targets := clean mrproper distclean \
 			 cscope TAGS tags help %docs check% \
 			 include/linux/version.h headers_% \
-			 kernelrelease kernelversion
+			 kernelversion
 
 config-targets := 0
 mixed-targets  := 0
@@ -1468,8 +1468,7 @@ checkstack:
 	$(PERL) $(src)/scripts/checkstack.pl $(CHECKSTACK_ARCH)
 
 kernelrelease:
-	$(if $(wildcard include/config/kernel.release), $(Q)echo $(KERNELRELEASE), \
-	$(error kernelrelease not valid - run 'make prepare' to update it))
+	@echo $(kernelrelease)
 kernelversion:
 	@echo $(KERNELVERSION)
 
-- 
1.6.5.2

