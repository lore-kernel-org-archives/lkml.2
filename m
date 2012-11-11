Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481Ab2KKCVc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 21:21:32 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51113 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab2KKCVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 21:21:31 -0500
Message-ID: <1352600482.23129.1.camel@phoenix>
Subject: [PATCH 1/2] pinctrl: tegra: Make PINCTRL_TEGRA select PINMUX &&
 PINCONF
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Date: Sun, 11 Nov 2012 10:21:22 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Then we can remove "select PINMUX && PINCONF" from PINCTRL_TEGRA{20,30}.
This simplifies the dependency.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pinctrl/Kconfig |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index 6d5a50b..fc0f49a 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -157,18 +157,16 @@ config PINCTRL_SIRF
 	select PINMUX
 
 config PINCTRL_TEGRA
+	select PINMUX
+	select PINCONF
 	bool
 
 config PINCTRL_TEGRA20
 	bool
-	select PINMUX
-	select PINCONF
 	select PINCTRL_TEGRA
 
 config PINCTRL_TEGRA30
 	bool
-	select PINMUX
-	select PINCONF
 	select PINCTRL_TEGRA
 
 config PINCTRL_U300
-- 
1.7.9.5



