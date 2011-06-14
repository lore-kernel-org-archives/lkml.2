Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab1FNBSd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 21:18:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:30478 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214Ab1FNBSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 21:18:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,361,1304319600"; 
   d="scan'208";a="14139562"
Subject: 3.0-rc3 patch compile issue
From: "Alex,Shi" <alex.shi@intel.com>
To: linux-kernel@vger.kernel.org
Cc: torvalds@osdl.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Jun 2011 09:18:09 +0800
Message-ID: <1308014289.21027.1455.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rc3
patch(http://www.kernel.org/pub/linux/kernel/v3.0/testing/patch-3.0-rc3.bz2) can not be compiled since srcipts/depmod.sh is not executable but Makefile want to it be. 

$ ll scripts/depmod.sh 
-rw-rw-r-- 1 alexs alexs 1231 2011-06-14 16:11 scripts/depmod.sh

But the file attribute is correct in Linus' git tree. So, the guys need
to update above patch file or change something in Makefile. 

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
diff --git a/Makefile b/Makefile
index badb923..2a26917 100644
--- a/Makefile
+++ b/Makefile
@@ -1526,7 +1526,7 @@ quiet_cmd_rmfiles = $(if $(wildcard $(rm-files)),CLEAN   $(wildcard $(rm-files))
 
 # Run depmod only if we have System.map and depmod is executable
 quiet_cmd_depmod = DEPMOD  $(KERNELRELEASE)
-      cmd_depmod = $(srctree)/scripts/depmod.sh $(DEPMOD) $(KERNELRELEASE)
+      cmd_depmod = $(shell $(CONFIG_SHELL) $(srctree)/scripts/depmod.sh $(DEPMOD) $(KERNELRELEASE))
 
 # Create temporary dir for module support files
 # clean it up only when building all modules


