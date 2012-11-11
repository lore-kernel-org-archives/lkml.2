Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab2KKCWt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 21:22:49 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:46904 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab2KKCWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 21:22:48 -0500
Message-ID: <1352600562.23129.3.camel@phoenix>
Subject: [PATCH 2/2] pinctrl: mxs: Make PINCTRL_MXS select PINMUX && PINCONF
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Shawn Guo <shawn.guo@linaro.org>, Dong Aisheng <dong.aisheng@linaro.org>,
        Devendra Naga <devendra.aaru@gmail.com>,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Date: Sun, 11 Nov 2012 10:22:42 +0800
In-Reply-To: <1352600482.23129.1.camel@phoenix>
References: <1352600482.23129.1.camel@phoenix>
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
---
 drivers/pinctrl/Kconfig |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index fc0f49a..d5c9431 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -99,18 +99,16 @@ config PINCTRL_MMP2
 	select PINCONF
 
 config PINCTRL_MXS
+	select PINMUX
+	select PINCONF
 	bool
 
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



