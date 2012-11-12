Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab2KLCAd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 21:00:33 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62697 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab2KLCAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 21:00:31 -0500
Message-ID: <1352685622.4984.0.camel@phoenix>
Subject: [PATCH v2 1/2] pinctrl: tegra: Make PINCTRL_TEGRA select PINMUX &&
 PINCONF
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Date: Mon, 12 Nov 2012 10:00:22 +0800
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
index 6d5a50b..007704f 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -158,17 +158,15 @@ config PINCTRL_SIRF
 
 config PINCTRL_TEGRA
 	bool
+	select PINMUX
+	select PINCONF
 
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



