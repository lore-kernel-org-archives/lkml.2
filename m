Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701Ab2FUHcO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 03:32:14 -0400
Received: from void.printf.net ([89.145.121.20]:38049 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758642Ab2FUHcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 03:32:13 -0400
From: Chris Ball <cjb@laptop.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Mitch Bradley <wmb@laptop.org>, mturquette@linaro.org,
        devicetree-discuss@lists.ozlabs.org, sboyd@codeaurora.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>, skannan@codeaurora.org,
        shawn.guo@linaro.org, s.hauer@pengutronix.de,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 02/02] clk: clk-of: Use alloc_bootmem() instead of kzalloc()
References: <1339512111-11172-1-git-send-email-robherring2@gmail.com>
	<87bokd15x7.fsf@octavius.laptop.org>
Date: Thu, 21 Jun 2012 03:32:04 -0400
In-Reply-To: <87bokd15x7.fsf@octavius.laptop.org> (Chris Ball's message of
	"Thu, 21 Jun 2012 03:27:00 -0400")
Message-ID: <87395p15or.fsf_-_@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When of_clk_add_provider() is used at boot time (during .init_early on
ARM, in the motivating case for this patch), kzalloc() cannot be used
because slab isn't up yet.

Signed-off-by: Chris Ball <cjb@laptop.org>
---
 drivers/clk/clk-of.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/clk-of.c b/drivers/clk/clk-of.c
index 8b43416..adbb56b 100644
--- a/drivers/clk/clk-of.c
+++ b/drivers/clk/clk-of.c
@@ -22,6 +22,7 @@
 #include <linux/list.h>
 #include <linux/slab.h>
 #include <linux/of.h>
+#include <linux/bootmem.h>
 
 #ifdef CONFIG_OF
 
@@ -67,7 +68,7 @@ int of_clk_add_provider(struct device_node *np,
 {
 	struct of_clk_provider *cp;
 
-	cp = kzalloc(sizeof(struct of_clk_provider), GFP_KERNEL);
+	cp = alloc_bootmem(sizeof(struct of_clk_provider));
 	if (!cp)
 		return -ENOMEM;
 
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
