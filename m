Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab2LYO66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 09:58:58 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:55864 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760Ab2LYO64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 09:58:56 -0500
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH 3/3] staging: drm/imx: fix double free bug in error path
Date: Tue, 25 Dec 2012 15:58:39 +0100
Message-Id: <5678dc4552e919b1ed51856e50023813f9eb37d6.1356447103.git.LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <56060bcfc2aa06b884380d07af72fc5db6ef9685.1356447103.git.LW@KARO-electronics.de>
References: <56060bcfc2aa06b884380d07af72fc5db6ef9685.1356447103.git.LW@KARO-electronics.de>
In-Reply-To: <56060bcfc2aa06b884380d07af72fc5db6ef9685.1356447103.git.LW@KARO-electronics.de>
References: <56060bcfc2aa06b884380d07af72fc5db6ef9685.1356447103.git.LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kfree(imx_drm_encoder) is already being called at the label
'err_register'.

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/staging/imx-drm/imx-drm-core.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/imx-drm/imx-drm-core.c b/drivers/staging/imx-drm/imx-drm-core.c
index ecf0f44..cec19f1 100644
--- a/drivers/staging/imx-drm/imx-drm-core.c
+++ b/drivers/staging/imx-drm/imx-drm-core.c
@@ -584,7 +584,6 @@ int imx_drm_add_encoder(struct drm_encoder *encoder,
 
 	ret = imx_drm_encoder_register(imx_drm_encoder);
 	if (ret) {
-		kfree(imx_drm_encoder);
 		ret = -ENOMEM;
 		goto err_register;
 	}
-- 
1.7.2.5

