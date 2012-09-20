Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab2ITBdF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 21:33:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33820 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab2ITBdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 21:33:03 -0400
Message-ID: <1348104773.18148.2.camel@phoenix>
Subject: [PATCH RFT] memory: tegra{20,30}-mc: Fix reading incorrect register
 in mc_readl()
From: Axel Lin <axel.lin@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hiroshi DOYU <hdoyu@nvidia.com>, Stephen Warren <swarren@wwwdotorg.org>,
        linux-kernel@vger.kernel.org
Date: Thu, 20 Sep 2012 09:32:53 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code reading the register does not match the code writing to the register,
fix it.

Also fix the coding style in mc_writel() for better readability.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/memory/tegra20-mc.c |   10 +++-------
 drivers/memory/tegra30-mc.c |   22 +++++++---------------
 2 files changed, 10 insertions(+), 22 deletions(-)

diff --git a/drivers/memory/tegra20-mc.c b/drivers/memory/tegra20-mc.c
index 3ed49c1..e6764bb 100644
--- a/drivers/memory/tegra20-mc.c
+++ b/drivers/memory/tegra20-mc.c
@@ -57,7 +57,7 @@ static inline u32 mc_readl(struct tegra20_mc *mc, u32 offs)
 
 	if (offs < 0x24)
 		val = readl(mc->regs[0] + offs);
-	if (offs < 0x400)
+	else if (offs < 0x400)
 		val = readl(mc->regs[1] + offs - 0x3c);
 
 	return val;
@@ -65,14 +65,10 @@ static inline u32 mc_readl(struct tegra20_mc *mc, u32 offs)
 
 static inline void mc_writel(struct tegra20_mc *mc, u32 val, u32 offs)
 {
-	if (offs < 0x24) {
+	if (offs < 0x24)
 		writel(val, mc->regs[0] + offs);
-		return;
-	}
-	if (offs < 0x400) {
+	else if (offs < 0x400)
 		writel(val, mc->regs[1] + offs - 0x3c);
-		return;
-	}
 }
 
 static const char * const tegra20_mc_client[] = {
diff --git a/drivers/memory/tegra30-mc.c b/drivers/memory/tegra30-mc.c
index e56ff04..802b9ea 100644
--- a/drivers/memory/tegra30-mc.c
+++ b/drivers/memory/tegra30-mc.c
@@ -95,11 +95,11 @@ static inline u32 mc_readl(struct tegra30_mc *mc, u32 offs)
 
 	if (offs < 0x10)
 		val = readl(mc->regs[0] + offs);
-	if (offs < 0x1f0)
+	else if (offs < 0x1f0)
 		val = readl(mc->regs[1] + offs - 0x3c);
-	if (offs < 0x228)
+	else if (offs < 0x228)
 		val = readl(mc->regs[2] + offs - 0x200);
-	if (offs < 0x400)
+	else if (offs < 0x400)
 		val = readl(mc->regs[3] + offs - 0x284);
 
 	return val;
@@ -107,22 +107,14 @@ static inline u32 mc_readl(struct tegra30_mc *mc, u32 offs)
 
 static inline void mc_writel(struct tegra30_mc *mc, u32 val, u32 offs)
 {
-	if (offs < 0x10) {
+	if (offs < 0x10)
 		writel(val, mc->regs[0] + offs);
-		return;
-	}
-	if (offs < 0x1f0) {
+	else if (offs < 0x1f0)
 		writel(val, mc->regs[1] + offs - 0x3c);
-		return;
-	}
-	if (offs < 0x228) {
+	else if (offs < 0x228)
 		writel(val, mc->regs[2] + offs - 0x200);
-		return;
-	}
-	if (offs < 0x400) {
+	else if (offs < 0x400)
 		writel(val, mc->regs[3] + offs - 0x284);
-		return;
-	}
 }
 
 static const char * const tegra30_mc_client[] = {
-- 
1.7.9.5



