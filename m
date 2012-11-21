Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab2KUC04 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 21:26:56 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:46899 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896Ab2KUC0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 21:26:53 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Subject: [PATCH 06/42] sh-pfc: Let the compiler decide whether to inline functions
Date: Wed, 21 Nov 2012 03:27:07 +0100
Message-Id: <1353464863-10281-7-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1353464863-10281-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1353464863-10281-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The compiler should be smart enough to automatically inline static
functions that are called from a single location.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/sh/pfc/pinctrl.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/sh/pfc/pinctrl.c b/drivers/sh/pfc/pinctrl.c
index 1c93e3c..21b8678 100644
--- a/drivers/sh/pfc/pinctrl.c
+++ b/drivers/sh/pfc/pinctrl.c
@@ -115,7 +115,7 @@ static void sh_pfc_noop_disable(struct pinctrl_dev *pctldev, unsigned func,
 {
 }
 
-static inline int sh_pfc_config_function(struct sh_pfc *pfc, unsigned offset)
+static int sh_pfc_config_function(struct sh_pfc *pfc, unsigned offset)
 {
 	if (sh_pfc_config_gpio(pfc, offset,
 			       PINMUX_TYPE_FUNCTION,
@@ -327,10 +327,10 @@ static struct pinctrl_desc sh_pfc_pinctrl_desc = {
 	.confops	= &sh_pfc_pinconf_ops,
 };
 
-static inline void __devinit sh_pfc_map_one_gpio(struct sh_pfc *pfc,
-						 struct sh_pfc_pinctrl *pmx,
-						 struct pinmux_gpio *gpio,
-						 unsigned offset)
+static void __devinit sh_pfc_map_one_gpio(struct sh_pfc *pfc,
+					  struct sh_pfc_pinctrl *pmx,
+					  struct pinmux_gpio *gpio,
+					  unsigned offset)
 {
 	struct pinmux_data_reg *dummy;
 	unsigned long flags;
-- 
1.7.8.6

