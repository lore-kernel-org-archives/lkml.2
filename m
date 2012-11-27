Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab2K0OuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 09:50:05 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42620 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203Ab2K0OuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 09:50:04 -0500
Message-ID: <1354027788.13128.1.camel@phoenix>
Subject: [PATCH] pinctrl: exynos5440/samsung: Staticize pcfgs
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 27 Nov 2012 22:49:48 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got below build error with random config if CONFIG_PINCTRL_SAMSUNG=y &&
CONFIG_PINCTRL_EXYNOS5440=y.

Fix the build error by making pcfgs static.

  LD      drivers/pinctrl/built-in.o
drivers/pinctrl/pinctrl-exynos5440.o: In function `.LANCHOR0':
pinctrl-exynos5440.c:(.data+0x54): multiple definition of `pcfgs'
drivers/pinctrl/pinctrl-samsung.o:pinctrl-samsung.c:(.data+0x54): first defined here
make[2]: *** [drivers/pinctrl/built-in.o] Error 1
make[1]: *** [drivers/pinctrl] Error 2
make: *** [drivers] Error 2

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pinctrl/pinctrl-exynos5440.c |    2 +-
 drivers/pinctrl/pinctrl-samsung.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-exynos5440.c b/drivers/pinctrl/pinctrl-exynos5440.c
index b8635f6..07db895 100644
--- a/drivers/pinctrl/pinctrl-exynos5440.c
+++ b/drivers/pinctrl/pinctrl-exynos5440.c
@@ -117,7 +117,7 @@ struct exynos5440_pinctrl_priv_data {
 };
 
 /* list of all possible config options supported */
-struct pin_config {
+static struct pin_config {
 	char		*prop_cfg;
 	unsigned int	cfg_type;
 } pcfgs[] = {
diff --git a/drivers/pinctrl/pinctrl-samsung.c b/drivers/pinctrl/pinctrl-samsung.c
index 8f31b65..864fed8 100644
--- a/drivers/pinctrl/pinctrl-samsung.c
+++ b/drivers/pinctrl/pinctrl-samsung.c
@@ -37,7 +37,7 @@
 #define FSUFFIX_LEN		sizeof(FUNCTION_SUFFIX)
 
 /* list of all possible config options supported */
-struct pin_config {
+static struct pin_config {
 	char		*prop_cfg;
 	unsigned int	cfg_type;
 } pcfgs[] = {
-- 
1.7.9.5



