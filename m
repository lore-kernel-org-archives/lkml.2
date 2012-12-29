Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab2L2AnE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 19:43:04 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:59507 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112Ab2L2AnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 19:43:01 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Shawn Guo <shawn.guo@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 1/2] ARM: dts: prevent *.dtb from always being rebuilt
Date: Fri, 28 Dec 2012 17:42:46 -0700
Message-Id: <1356741767-29292-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

if_changed (used by the *.dts->*.dtc rule) rebuilds files if they aren't
contained in $(targets). (make V=2 indicates this). Add $(dtb-y) to
$(targets) to prevent *.dtb from always being rebuilt.

This fixes a regression introduced by the .dtb rule rework in 499cd82
"ARM: dt: change .dtb build rules to build in dts directory".

Reported-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 arch/arm/boot/dts/Makefile |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index e44da40..5ebb44f 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -155,6 +155,7 @@ dtb-$(CONFIG_ARCH_VT8500) += vt8500-bv07.dtb \
 dtb-$(CONFIG_ARCH_ZYNQ) += zynq-zc702.dtb
 
 targets += dtbs
+targets += $(dtb-y)
 endif
 
 # *.dtb used to be generated in the directory above. Clean out the
-- 
1.7.10.4

