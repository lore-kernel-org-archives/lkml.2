Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100Ab2ACHrs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 02:47:48 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:17504 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab2ACHrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 02:47:37 -0500
X-AuditID: cbfee61a-b7b89ae000001a15-c4-4f02b29656b1
From: Chanho Park <chanho61.park@samsung.com>
To: linus.walleij@linaro.org, swarren@nvidia.com, Baohua.Song@csr.com
Cc: linux-kernel@vger.kernel.org, Chanho Park <chanho61.park@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 2/2] pinctrl: remove unnecessary max pin number
Date: Tue, 03 Jan 2012 16:47:51 +0900
Message-id: <1325576871-9397-3-git-send-email-chanho61.park@samsung.com>
X-Mailer: git-send-email 1.7.5.4
In-reply-to: <1325576871-9397-1-git-send-email-chanho61.park@samsung.com>
References: <1325576871-9397-1-git-send-email-chanho61.park@samsung.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes maxpin member in the pin control descriptor
because we don't need this value as we enumerate a pin space
using offset.

Signed-off-by: Chanho Park <chanho61.park@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/pinctrl/core.c          |    1 -
 drivers/pinctrl/pinctrl-sirf.c  |    1 -
 drivers/pinctrl/pinctrl-u300.c  |    1 -
 include/linux/pinctrl/pinctrl.h |    5 -----
 4 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 03a1dd6..dfd7232 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -382,7 +382,6 @@ static int pinctrl_pins_show(struct seq_file *s, void *what)
 	unsigned i, pin;
 
 	seq_printf(s, "registered pins: %d\n", pctldev->desc->npins);
-	seq_printf(s, "max pin number: %d\n", pctldev->desc->maxpin);
 
 	/* The pin number can be retrived from the pin controller descriptor */
 	for (i = 0; i < pctldev->desc->npins; i++) {
diff --git a/drivers/pinctrl/pinctrl-sirf.c b/drivers/pinctrl/pinctrl-sirf.c
index 99e688e..6b3534c 100644
--- a/drivers/pinctrl/pinctrl-sirf.c
+++ b/drivers/pinctrl/pinctrl-sirf.c
@@ -1086,7 +1086,6 @@ static struct pinctrl_desc sirfsoc_pinmux_desc = {
 	.name = DRIVER_NAME,
 	.pins = sirfsoc_pads,
 	.npins = ARRAY_SIZE(sirfsoc_pads),
-	.maxpin = SIRFSOC_NUM_PADS - 1,
 	.pctlops = &sirfsoc_pctrl_ops,
 	.pmxops = &sirfsoc_pinmux_ops,
 	.owner = THIS_MODULE,
diff --git a/drivers/pinctrl/pinctrl-u300.c b/drivers/pinctrl/pinctrl-u300.c
index 5a01da1..03d3cb8 100644
--- a/drivers/pinctrl/pinctrl-u300.c
+++ b/drivers/pinctrl/pinctrl-u300.c
@@ -1108,7 +1108,6 @@ static struct pinctrl_desc u300_pmx_desc = {
 	.name = DRIVER_NAME,
 	.pins = u300_pads,
 	.npins = ARRAY_SIZE(u300_pads),
-	.maxpin = U300_NUM_PADS-1,
 	.pctlops = &u300_pctrl_ops,
 	.pmxops = &u300_pmx_ops,
 	.confops = &u300_pconf_ops,
diff --git a/include/linux/pinctrl/pinctrl.h b/include/linux/pinctrl/pinctrl.h
index ac22827..5904725 100644
--- a/include/linux/pinctrl/pinctrl.h
+++ b/include/linux/pinctrl/pinctrl.h
@@ -114,10 +114,6 @@ struct pinctrl_ops {
  *	this pin controller
  * @npins: number of descriptors in the array, usually just ARRAY_SIZE()
  *	of the pins field above
- * @maxpin: since pin spaces may be sparse, there can he "holes" in the
- *	pin range, this attribute gives the maximum pin number in the
- *	total range. This should not be lower than npins for example,
- *	but may be equal to npins if you have no holes in the pin range.
  * @pctlops: pin control operation vtable, to support global concepts like
  *	grouping of pins, this is optional.
  * @pmxops: pinmux operations vtable, if you support pinmuxing in your driver
@@ -129,7 +125,6 @@ struct pinctrl_desc {
 	const char *name;
 	struct pinctrl_pin_desc const *pins;
 	unsigned int npins;
-	unsigned int maxpin;
 	struct pinctrl_ops *pctlops;
 	struct pinmux_ops *pmxops;
 	struct pinconf_ops *confops;
-- 
1.7.5.4

