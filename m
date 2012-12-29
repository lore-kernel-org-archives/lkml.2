Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab2L2AnG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 19:43:06 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:53339 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755140Ab2L2AnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 19:43:02 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Shawn Guo <shawn.guo@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 2/2] arm64: dts: prevent *.dtb from always being rebuilt
Date: Fri, 28 Dec 2012 17:42:47 -0700
Message-Id: <1356741767-29292-2-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1356741767-29292-1-git-send-email-swarren@wwwdotorg.org>
References: <1356741767-29292-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

if_changed (used by the *.dts->*.dtc rule) rebuilds files if they aren't
contained in $(targets). (make V=2 indicates this). Add $(dtb-y) to
$(targets) to prevent *.dtb from always being rebuilt. Note

This fixes a regression introduced by the .dtb rule rework in da4cbc6
"arm64: use new common dtc rule", although since arm64 doesn't actually
have any *.dts yet, this isn't a critical issue.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 arch/arm64/boot/dts/Makefile |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/Makefile b/arch/arm64/boot/dts/Makefile
index 801e2d7..32ac0ae 100644
--- a/arch/arm64/boot/dts/Makefile
+++ b/arch/arm64/boot/dts/Makefile
@@ -1,4 +1,5 @@
 targets += dtbs
+targets += $(dtb-y)
 
 dtbs: $(addprefix $(obj)/, $(dtb-y))
 
-- 
1.7.10.4

