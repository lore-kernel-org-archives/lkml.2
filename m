Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750Ab2DDDyI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 23:54:08 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39431 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab2DDDyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 23:54:06 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: linus.walleij@linaro.org
Cc: sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] pinctrl: fix build when CONFIG_OF && !CONFIG_PINCTRL
Date: Tue,  3 Apr 2012 21:53:56 -0600
Message-Id: <1333511636-9987-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.5.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

pinctrl/devicetree.c won't compile when !CONFIG_PINCTRL, since the
pinctrl headers don't declare some types when !PINCTRL. Make sure
pinctrl/Makefile only attempts to compile devicetree.c when OF &&
PINCTRL.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/pinctrl/Makefile |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
index 049c9fb..8e3c95a 100644
--- a/drivers/pinctrl/Makefile
+++ b/drivers/pinctrl/Makefile
@@ -5,7 +5,9 @@ ccflags-$(CONFIG_DEBUG_PINCTRL)	+= -DDEBUG
 obj-$(CONFIG_PINCTRL)		+= core.o
 obj-$(CONFIG_PINMUX)		+= pinmux.o
 obj-$(CONFIG_PINCONF)		+= pinconf.o
-obj-$(CONFIG_OF)		+= devicetree.o
+ifeq ($(CONFIG_OF),y)
+obj-$(CONFIG_PINCTRL)		+= devicetree.o
+endif
 obj-$(CONFIG_GENERIC_PINCONF)	+= pinconf-generic.o
 obj-$(CONFIG_PINCTRL_PXA3xx)	+= pinctrl-pxa3xx.o
 obj-$(CONFIG_PINCTRL_MMP2)	+= pinctrl-mmp2.o
-- 
1.7.5.4

