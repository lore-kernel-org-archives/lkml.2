Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab2KUCf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 21:35:27 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:46904 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072Ab2KUC04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 21:26:56 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Subject: [PATCH 13/42] sh-pfc: Remove platform device registration
Date: Wed, 21 Nov 2012 03:27:14 +0100
Message-Id: <1353464863-10281-14-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1353464863-10281-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1353464863-10281-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PFC platform device is now registered by arch code, remove the
legacy registration mechanism.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/sh/pfc/core.c  |   12 ------------
 include/linux/sh_pfc.h |   10 ----------
 2 files changed, 0 insertions(+), 22 deletions(-)

diff --git a/drivers/sh/pfc/core.c b/drivers/sh/pfc/core.c
index 4e4adc7..eeec76f 100644
--- a/drivers/sh/pfc/core.c
+++ b/drivers/sh/pfc/core.c
@@ -603,18 +603,6 @@ static struct platform_driver sh_pfc_driver = {
 	},
 };
 
-static struct platform_device sh_pfc_device = {
-	.name		= DRV_NAME,
-	.id		= -1,
-};
-
-int __init register_sh_pfc(struct sh_pfc_platform_data *pdata)
-{
-	sh_pfc_device.dev.platform_data = pdata;
-
-	return platform_device_register(&sh_pfc_device);
-}
-
 static int __init sh_pfc_init(void)
 {
 	return platform_driver_register(&sh_pfc_driver);
diff --git a/include/linux/sh_pfc.h b/include/linux/sh_pfc.h
index f7f01b2..fa1fec0 100644
--- a/include/linux/sh_pfc.h
+++ b/include/linux/sh_pfc.h
@@ -120,16 +120,6 @@ struct sh_pfc_platform_data {
 /* XXX compat for now */
 #define pinmux_info sh_pfc_platform_data
 
-/* drivers/sh/pfc/core.c */
-int register_sh_pfc(struct sh_pfc_platform_data *pfc);
-
-/* xxx */
-static inline int register_pinmux(struct pinmux_info *pip)
-{
-	struct sh_pfc_platform_data *pdata = pip;
-	return register_sh_pfc(pdata);
-}
-
 enum { GPIO_CFG_DRYRUN, GPIO_CFG_REQ, GPIO_CFG_FREE };
 
 /* helper macro for port */
-- 
1.7.8.6

