Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161585Ab2CPUzC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 16:55:02 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:41180 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965123Ab2CPUyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 16:54:49 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, B29396@freescale.com,
        s.hauer@pengutronix.de, dongas86@gmail.com, shawn.guo@linaro.org,
        thomas.abraham@linaro.org, tony@atomide.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-tegra@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>
Subject: [PATCH 2/8] pinctrl: Include <linux/bug.h> to prevent compile errors
Date: Fri, 16 Mar 2012 14:54:23 -0600
Message-Id: <1331931269-12262-2-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1331931269-12262-1-git-send-email-swarren@wwwdotorg.org>
References: <1331931269-12262-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Macros in <linux/pinctrl/machine.h> call ARRAY_SIZE(), the definition of
which eventually calls BUILD_BUG_ON_ZERO(), which is defined in
<linux/bug.h>. Include that so that every .c file using the pinctrl macros
doesn't have to do that itself.

Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
---
v2: Fix accidental replacing of pinctrl-state.h with pinctrl.h
---
 include/linux/pinctrl/machine.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/pinctrl/machine.h b/include/linux/pinctrl/machine.h
index fee4349..226444e 100644
--- a/include/linux/pinctrl/machine.h
+++ b/include/linux/pinctrl/machine.h
@@ -12,6 +12,8 @@
 #ifndef __LINUX_PINCTRL_MACHINE_H
 #define __LINUX_PINCTRL_MACHINE_H
 
+#include <linux/bug.h>
+
 #include "pinctrl-state.h"
 
 enum pinctrl_map_type {
-- 
1.7.0.4

