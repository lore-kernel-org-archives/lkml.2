Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030196Ab2EKKFX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 06:05:23 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1797 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932312Ab2EKKFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 06:05:20 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 11 May 2012 03:05:08 -0700
From: Hiroshi DOYU <hdoyu@nvidia.com>
To: <gregkh@linuxfoundation.org>, <swarren@wwwdotorg.org>
CC: <linux-tegra@vger.kernel.org>, Hiroshi DOYU <hdoyu@nvidia.com>,
        <linux-kernel@vger.kernel.org>
Subject: [v2 1/2] ARM: tegra20: MC: Remove unnecessary BUG*()
Date: Fri, 11 May 2012 13:04:44 +0300
Message-ID: <1336730689-27092-1-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1336717334-23276-2-git-send-email-hdoyu@nvidia.com>
References: <1336717334-23276-2-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Accessing interleaved MC register offsets/ranges are verified. BUG*()s
in accessors can be removed.

Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
---
 drivers/memory/tegra20-mc.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/memory/tegra20-mc.c b/drivers/memory/tegra20-mc.c
index c0bfffa..2a437e9 100644
--- a/drivers/memory/tegra20-mc.c
+++ b/drivers/memory/tegra20-mc.c
@@ -53,12 +53,14 @@ struct tegra20_mc {
 
 static inline u32 mc_readl(struct tegra20_mc *mc, u32 offs)
 {
+	u32 val = 0;
+
 	if (offs < 0x24)
-		return readl(mc->regs[0] + offs);
-	BUG_ON(offs < 0x3c);
+		val = readl(mc->regs[0] + offs);
 	if (offs < 0x400)
-		return readl(mc->regs[1] + offs - 0x3c);
-	BUG();
+		val = readl(mc->regs[1] + offs - 0x3c);
+
+	return val;
 }
 
 static inline void mc_writel(struct tegra20_mc *mc, u32 val, u32 offs)
@@ -67,12 +69,10 @@ static inline void mc_writel(struct tegra20_mc *mc, u32 val, u32 offs)
 		writel(val, mc->regs[0] + offs);
 		return;
 	}
-	BUG_ON(offs < 0x3c);
 	if (offs < 0x400) {
 		writel(val, mc->regs[1] + offs - 0x3c);
 		return;
 	}
-	BUG();
 }
 
 static const char * const tegra20_mc_client[] = {
-- 
1.7.5.4

