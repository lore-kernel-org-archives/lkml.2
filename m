Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab3AHBjK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 20:39:10 -0500
Received: from mail-ye0-f173.google.com ([209.85.213.173]:47999 "EHLO
	mail-ye0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647Ab3AHBjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 20:39:08 -0500
From: Fabio Estevam <festevam@gmail.com>
To: mturquette@linaro.org
Cc: shawn.guo@linaro.org, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] clk: mxs: Index is always positive
Date: Mon,  7 Jan 2013 23:38:55 -0200
Message-Id: <1357609135-13922-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Fix the following warnings when building with W=1 option:

drivers/clk/mxs/clk-imx23.c: In function 'mx23_clocks_init':
drivers/clk/mxs/clk-imx23.c:149:16: warning: comparison between signed and unsigned integer expressions [-Wsign-compare]
drivers/clk/mxs/clk-imx23.c:165:16: warning: comparison between signed and unsigned integer expressions [-Wsign-compare]
...

drivers/clk/mxs/clk-imx28.c: In function 'mx28_clocks_init':
drivers/clk/mxs/clk-imx28.c:227:16: warning: comparison between signed and unsigned integer expressions [-Wsign-compare]
drivers/clk/mxs/clk-imx28.c:244:16: warning: comparison between signed and unsigned integer expressions [-Wsign-compare]

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
----
 drivers/clk/mxs/clk-imx23.c |    2 +-
 drivers/clk/mxs/clk-imx28.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/mxs/clk-imx23.c b/drivers/clk/mxs/clk-imx23.c
index 8dd476e..b5c06f9 100644
--- a/drivers/clk/mxs/clk-imx23.c
+++ b/drivers/clk/mxs/clk-imx23.c
@@ -99,7 +99,7 @@ static enum imx23_clk clks_init_on[] __initdata = {
 int __init mx23_clocks_init(void)
 {
 	struct device_node *np;
-	int i;
+	u32 i;
 
 	clk_misc_init();
 
diff --git a/drivers/clk/mxs/clk-imx28.c b/drivers/clk/mxs/clk-imx28.c
index db3af08..126370a 100644
--- a/drivers/clk/mxs/clk-imx28.c
+++ b/drivers/clk/mxs/clk-imx28.c
@@ -154,7 +154,7 @@ static enum imx28_clk clks_init_on[] __initdata = {
 int __init mx28_clocks_init(void)
 {
 	struct device_node *np;
-	int i;
+	u32 i;
 
 	clk_misc_init();
 
-- 
1.7.9.5

