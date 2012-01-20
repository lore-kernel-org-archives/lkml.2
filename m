Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab2ATQRp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 11:17:45 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:48983 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665Ab2ATQRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 11:17:38 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18rha14F42S56QFRSx3jszU
Subject: [PATCH 4/4] pinctrl: Fix some pinmux typos
To: linux-kernel@vger.kernel.org
From: Tony Lindgren <tony@atomide.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Barry Song <21cnbao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>
Date: Fri, 20 Jan 2012 08:17:33 -0800
Message-ID: <20120120161733.21955.57648.stgit@kaulin.local>
In-Reply-To: <20120120161610.21955.25082.stgit@kaulin.local>
References: <20120120161610.21955.25082.stgit@kaulin.local>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some pinmux typos so implementing pinmux drivers
is a bit easier.

Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 Documentation/pinctrl.txt |    2 +-
 drivers/pinctrl/pinmux.c  |    9 ++-------
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
index 6727b92..4af17a0 100644
--- a/Documentation/pinctrl.txt
+++ b/Documentation/pinctrl.txt
@@ -1025,7 +1025,7 @@ it, disables and releases it, and muxes it in on the pins defined by group B:
 
 foo_switch()
 {
-	struct pinmux pmx;
+	struct pinmux *pmx;
 
 	/* Enable on position A */
 	pmx = pinmux_get(&device, "spi0-pos-A");
diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index ffe633d..8acf54e 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -53,11 +53,6 @@ struct pinmux_group {
  * @dev: the device using this pinmux
  * @usecount: the number of active users of this mux setting, used to keep
  *	track of nested use cases
- * @pins: an array of discrete physical pins used in this mapping, taken
- *	from the global pin enumeration space (copied from pinmux map)
- * @num_pins: the number of pins in this mapping array, i.e. the number of
- *	elements in .pins so we can iterate over that array (copied from
- *	pinmux map)
  * @pctldev: pin control device handling this pinmux
  * @func_selector: the function selector for the pinmux device handling
  *	this pinmux
@@ -411,7 +406,7 @@ int __init pinmux_register_mappings(struct pinmux_map const *maps,
 }
 
 /**
- * acquire_pins() - acquire all the pins for a certain funcion on a pinmux
+ * acquire_pins() - acquire all the pins for a certain function on a pinmux
  * @pctldev: the device to take the pins on
  * @func_selector: the function selector to acquire the pins for
  * @group_selector: the group selector containing the pins to acquire
@@ -458,7 +453,7 @@ static int acquire_pins(struct pinctrl_dev *pctldev,
 
 /**
  * release_pins() - release pins taken by earlier acquirement
- * @pctldev: the device to free the pinx on
+ * @pctldev: the device to free the pins on
  * @group_selector: the group selector containing the pins to free
  */
 static void release_pins(struct pinctrl_dev *pctldev,

