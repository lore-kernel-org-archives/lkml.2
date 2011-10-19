Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134Ab1JSWTi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 18:19:38 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:49333 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130Ab1JSWTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 18:19:37 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Barry Song <21cnbao@gmail.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rongjun Ying <Rongjun.Ying@csr.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 2/4] pinctrl: Remove unsafe __refdata
Date: Wed, 19 Oct 2011 16:19:26 -0600
Message-Id: <1319062768-26391-2-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319062768-26391-1-git-send-email-swarren@nvidia.com>
References: <1319062768-26391-1-git-send-email-swarren@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A pin controller's pin definitions are used both during pinctrl_register()
and pinctrl_unregister(). The latter happens outside of __init/__devinit
time, and hence it is unsafe to mark the pin array as __refdata.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/pinctrl/pinmux-sirf.c |    2 +-
 drivers/pinctrl/pinmux-u300.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinmux-sirf.c b/drivers/pinctrl/pinmux-sirf.c
index cad4f5d..3bc083c 100644
--- a/drivers/pinctrl/pinmux-sirf.c
+++ b/drivers/pinctrl/pinmux-sirf.c
@@ -30,7 +30,7 @@
  * pad list for the pinmux subsystem
  * refer to CS-131858-DC-6A.xls
  */
-static const struct pinctrl_pin_desc __refdata sirfsoc_pads[] = {
+static const struct pinctrl_pin_desc sirfsoc_pads[] = {
 	PINCTRL_PIN(4, "pwm0"),
 	PINCTRL_PIN(5, "pwm1"),
 	PINCTRL_PIN(6, "pwm2"),
diff --git a/drivers/pinctrl/pinmux-u300.c b/drivers/pinctrl/pinmux-u300.c
index be6e04d..ed8bcd8 100644
--- a/drivers/pinctrl/pinmux-u300.c
+++ b/drivers/pinctrl/pinmux-u300.c
@@ -179,7 +179,7 @@
 #define U300_NUM_PADS 467
 
 /* Pad names for the pinmux subsystem */
-static const struct pinctrl_pin_desc __refdata u300_pads[] = {
+static const struct pinctrl_pin_desc u300_pads[] = {
 	/* Pads along the top edge of the chip */
 	PINCTRL_PIN(0, "P PAD VDD 28"),
 	PINCTRL_PIN(1, "P PAD GND 28"),
-- 
1.7.0.4

