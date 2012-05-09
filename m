Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761060Ab2EIUZi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 16:25:38 -0400
Received: from mga03.intel.com ([143.182.124.21]:4526 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761025Ab2EIUZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 16:25:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="98246071"
From: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, hpa@linux.intel.com,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Subject: [PATCH] x86, realmode: build fix: remove duplicate build
Date: Wed,  9 May 2012 23:25:06 +0300
Message-Id: <1336595106-21135-1-git-send-email-jarkko.sakkinen@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Real-mode binary was built twice. This patch fixes
the issue by making realmode.relocs as target for
realmode.bin.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
---
 arch/x86/realmode/Makefile    |    3 ---
 arch/x86/realmode/rm/Makefile |    2 +-
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/x86/realmode/Makefile b/arch/x86/realmode/Makefile
index f22a4f8..615878e 100644
--- a/arch/x86/realmode/Makefile
+++ b/arch/x86/realmode/Makefile
@@ -15,6 +15,3 @@ $(obj)/rmpiggy.o: $(obj)/rm/realmode.relocs $(obj)/rm/realmode.bin
 
 $(obj)/rm/realmode.bin: FORCE
 	$(Q)$(MAKE) $(build)=$(obj)/rm $@
-
-$(obj)/rm/realmode.relocs: FORCE
-	$(Q)$(MAKE) $(build)=$(obj)/rm $@
diff --git a/arch/x86/realmode/rm/Makefile b/arch/x86/realmode/rm/Makefile
index de40bc4..1c1d3d3 100644
--- a/arch/x86/realmode/rm/Makefile
+++ b/arch/x86/realmode/rm/Makefile
@@ -48,7 +48,7 @@ $(obj)/realmode.elf: $(obj)/realmode.lds $(REALMODE_OBJS) FORCE
 
 OBJCOPYFLAGS_realmode.bin := -O binary
 
-$(obj)/realmode.bin: $(obj)/realmode.elf
+$(obj)/realmode.bin: $(obj)/realmode.elf $(obj)/realmode.relocs
 	$(call if_changed,objcopy)
 
 quiet_cmd_relocs = RELOCS  $@
-- 
1.7.9.5

