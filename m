Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030208Ab2EKKFY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 06:05:24 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1808 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932416Ab2EKKFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 06:05:20 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 11 May 2012 03:05:14 -0700
From: Hiroshi DOYU <hdoyu@nvidia.com>
To: <gregkh@linuxfoundation.org>, <swarren@wwwdotorg.org>
CC: <linux-tegra@vger.kernel.org>, Hiroshi DOYU <hdoyu@nvidia.com>,
        <linux-kernel@vger.kernel.org>
Subject: [v2 2/2] ARM: tegra30: MC: Remove unnecessary BUG*()
Date: Fri, 11 May 2012 13:04:45 +0300
Message-ID: <1336730689-27092-2-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1336730689-27092-1-git-send-email-hdoyu@nvidia.com>
References: <1336717334-23276-2-git-send-email-hdoyu@nvidia.com>
 <1336730689-27092-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Accessing interleaved MC register offsets/ranges are verified. BUG*()s
in accessors can be removed.

Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
---
 drivers/memory/tegra30-mc.c |   20 ++++++++------------
 1 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/memory/tegra30-mc.c b/drivers/memory/tegra30-mc.c
index c982125..ec9fc78 100644
--- a/drivers/memory/tegra30-mc.c
+++ b/drivers/memory/tegra30-mc.c
@@ -91,18 +91,18 @@ struct tegra30_mc {
 
 static inline u32 mc_readl(struct tegra30_mc *mc, u32 offs)
 {
+	u32 val = 0;
+
 	if (offs < 0x10)
-		return readl(mc->regs[0] + offs);
-	BUG_ON(offs < 0x3c);
+		val = readl(mc->regs[0] + offs);
 	if (offs < 0x1f0)
-		return readl(mc->regs[1] + offs - 0x3c);
-	BUG_ON(offs < 0x200);
+		val = readl(mc->regs[1] + offs - 0x3c);
 	if (offs < 0x228)
-		return readl(mc->regs[2] + offs - 0x200);
-	BUG_ON(offs < 0x284);
+		val = readl(mc->regs[2] + offs - 0x200);
 	if (offs < 0x400)
-		return readl(mc->regs[3] + offs - 0x284);
-	BUG();
+		val = readl(mc->regs[3] + offs - 0x284);
+
+	return val;
 }
 
 static inline void mc_writel(struct tegra30_mc *mc, u32 val, u32 offs)
@@ -111,22 +111,18 @@ static inline void mc_writel(struct tegra30_mc *mc, u32 val, u32 offs)
 		writel(val, mc->regs[0] + offs);
 		return;
 	}
-	BUG_ON(offs < 0x3c);
 	if (offs < 0x1f0) {
 		writel(val, mc->regs[1] + offs - 0x3c);
 		return;
 	}
-	BUG_ON(offs < 0x200);
 	if (offs < 0x228) {
 		writel(val, mc->regs[2] + offs - 0x200);
 		return;
 	}
-	BUG_ON(offs < 0x284);
 	if (offs < 0x400) {
 		writel(val, mc->regs[3] + offs - 0x284);
 		return;
 	}
-	BUG();
 }
 
 static const char * const tegra30_mc_client[] = {
-- 
1.7.5.4

