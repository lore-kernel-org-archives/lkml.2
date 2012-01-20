Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab2ATQSu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 11:18:50 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:23831 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594Ab2ATQRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 11:17:35 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+FBdXy5s9ZataMbHuXc9YC
Subject: [PATCH 3/4] pinctrl: Add checks for empty names in
 pinmux_search_function
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
Date: Fri, 20 Jan 2012 08:17:30 -0800
Message-ID: <20120120161730.21955.40332.stgit@kaulin.local>
In-Reply-To: <20120120161610.21955.25082.stgit@kaulin.local>
References: <20120120161610.21955.25082.stgit@kaulin.local>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise we can get the following when dealing with
buggy data in a pinmux driver:

Unable to handle kernel NULL pointer dereference at virtual address 00000000
...
PC is at strcmp+0xc/0x34
LR is at pinmux_get+0x350/0x8f4
...

Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 drivers/pinctrl/pinmux.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 06b8943..ffe633d 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -584,6 +584,13 @@ static int pinmux_search_function(struct pinctrl_dev *pctldev,
 							   selector);
 		int ret;
 
+		if (!fname) {
+			pr_warning("no name for function%i\n",
+				   selector);
+			selector++;
+			continue;
+		}
+
 		if (!strcmp(map->function, fname)) {
 			/* Found the function, check pin group */
 			ret = pinmux_check_pin_group(pctldev, selector,

