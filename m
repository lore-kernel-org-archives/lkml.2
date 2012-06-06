Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759178Ab2FFW5t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 18:57:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38812 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508Ab2FFW5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 18:57:47 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH v8 1/4] MIPS: Don't define early_init_devtree() and device_tree_init() in prom.c for CPU_CAVIUM_OCTEON
Date: Wed,  6 Jun 2012 15:57:40 -0700
Message-Id: <1339023463-20267-2-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1339023463-20267-1-git-send-email-ddaney.cavm@gmail.com>
References: <1339023463-20267-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

This code is not common enough to be in a shared file, so OCTEON defines
it's own versions.

When the last of this target specific code is moved out, we can remove
all of this.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mips/kernel/prom.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/mips/kernel/prom.c b/arch/mips/kernel/prom.c
index f11b2bb..fcb325e 100644
--- a/arch/mips/kernel/prom.c
+++ b/arch/mips/kernel/prom.c
@@ -60,6 +60,7 @@ void __init early_init_dt_setup_initrd_arch(unsigned long start,
 }
 #endif
 
+#ifndef CONFIG_CPU_CAVIUM_OCTEON
 void __init early_init_devtree(void *params)
 {
 	/* Setup flat device-tree pointer */
@@ -108,3 +109,4 @@ void __init __dt_setup_arch(struct boot_param_header *bph)
 
 	early_init_devtree(initial_boot_params);
 }
+#endif /* !CONFIG_CPU_CAVIUM_OCTEON */
-- 
1.7.2.3

