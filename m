Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab2KLCCE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 21:02:04 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61770 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab2KLCCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 21:02:02 -0500
Message-ID: <1352685716.4984.2.camel@phoenix>
Subject: [PATCH v2 2/2] pinctrl: mxs: Make PINCTRL_MXS select PINMUX &&
 PINCONF
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Shawn Guo <shawn.guo@linaro.org>, Dong Aisheng <dong.aisheng@linaro.org>,
        Devendra Naga <devendra.aaru@gmail.com>,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Date: Mon, 12 Nov 2012 10:01:56 +0800
In-Reply-To: <1352685622.4984.0.camel@phoenix>
References: <1352685622.4984.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Then we can remove "select PINMUX && PINCONF" from PINCTRL_IMX{23,28}.
This simplifies the dependency.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Acked-by: Shawn Guo <shawn.guo@linaro.org>
---
 drivers/pinctrl/Kconfig |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index 007704f..0074873 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -100,17 +100,15 @@ config PINCTRL_MMP2
 
 config PINCTRL_MXS
 	bool
+	select PINMUX
+	select PINCONF
 
 config PINCTRL_IMX23
 	bool
-	select PINMUX
-	select PINCONF
 	select PINCTRL_MXS
 
 config PINCTRL_IMX28
 	bool
-	select PINMUX
-	select PINCONF
 	select PINCTRL_MXS
 
 config PINCTRL_NOMADIK
-- 
1.7.9.5



