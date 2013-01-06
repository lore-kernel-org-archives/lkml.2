Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab3AFOYS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 09:24:18 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:36095 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755867Ab3AFOYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 09:24:17 -0500
From: Denis Efremov <yefremov.denis@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Denis Efremov <yefremov.denis@gmail.com>,
        Mike Turquette <mturquette@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] clk: remove exported function from __init section
Date: Sun,  6 Jan 2013 18:21:43 +0400
Message-Id: <1357482103-14116-1-git-send-email-yefremov.denis@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbol of_fixed_clk_setup is exported and annotated __init.
This looks like section mismatch.
Fix this by removing the __init annotation of of_fixed_clk_setup.

Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
---
 drivers/clk/clk-fixed-rate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk-fixed-rate.c b/drivers/clk/clk-fixed-rate.c
index af78ed6..a53b53b 100644
--- a/drivers/clk/clk-fixed-rate.c
+++ b/drivers/clk/clk-fixed-rate.c
@@ -85,7 +85,7 @@ struct clk *clk_register_fixed_rate(struct device *dev, const char *name,
 /**
  * of_fixed_clk_setup() - Setup function for simple fixed rate clock
  */
-void __init of_fixed_clk_setup(struct device_node *node)
+void of_fixed_clk_setup(struct device_node *node)
 {
 	struct clk *clk;
 	const char *clk_name = node->name;
-- 
1.7.10.4

