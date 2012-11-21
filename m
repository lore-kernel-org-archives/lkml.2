Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab2KUChR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 21:37:17 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:46904 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044Ab2KUC0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 21:26:54 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Subject: [PATCH 09/42] sh-pfc: Split platform device and platform driver registration
Date: Wed, 21 Nov 2012 03:27:10 +0100
Message-Id: <1353464863-10281-10-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1353464863-10281-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1353464863-10281-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move platform driver registration to a static postcore initcall. This
prepares the move of platform device registration to arch code.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/sh/pfc/core.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/sh/pfc/core.c b/drivers/sh/pfc/core.c
index f1a0c85..9736e3d 100644
--- a/drivers/sh/pfc/core.c
+++ b/drivers/sh/pfc/core.c
@@ -597,19 +597,16 @@ static struct platform_device sh_pfc_device = {
 
 int __init register_sh_pfc(struct sh_pfc_platform_data *pdata)
 {
-	int rc;
-
 	sh_pfc_device.dev.platform_data = pdata;
 
-	rc = platform_driver_register(&sh_pfc_driver);
-	if (likely(!rc)) {
-		rc = platform_device_register(&sh_pfc_device);
-		if (unlikely(rc))
-			platform_driver_unregister(&sh_pfc_driver);
-	}
+	return platform_device_register(&sh_pfc_device);
+}
 
-	return rc;
+static int __init sh_pfc_init(void)
+{
+	return platform_driver_register(&sh_pfc_driver);
 }
+postcore_initcall(sh_pfc_init);
 
 static void __exit sh_pfc_exit(void)
 {
-- 
1.7.8.6

