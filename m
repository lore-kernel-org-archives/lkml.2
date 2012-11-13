Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab2KMMVB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 07:21:01 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57628 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab2KMMU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 07:20:59 -0500
Message-ID: <1352809250.4819.1.camel@phoenix>
Subject: [PATCH] pinctrl: spear: Make get_gpio_pingroup return NULL when no
 gpio_pingroup found
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org
Date: Tue, 13 Nov 2012 20:20:50 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently get_gpio_pingroup() may return NULL or ERR_PTR(-EINVAL) when
no gpio_pingroup found. The caller in gpio_request_endisable() only
checks if the return value is NULL. Return ERR_PTR(-EINVAL) for
get_gpio_pingroup() causes problem and seems not necessary.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pinctrl/spear/pinctrl-spear.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/spear/pinctrl-spear.c b/drivers/pinctrl/spear/pinctrl-spear.c
index 107780c..42bc267 100644
--- a/drivers/pinctrl/spear/pinctrl-spear.c
+++ b/drivers/pinctrl/spear/pinctrl-spear.c
@@ -284,12 +284,12 @@ static struct spear_gpio_pingroup *get_gpio_pingroup(struct spear_pmx *pmx,
 		unsigned pin)
 {
 	struct spear_gpio_pingroup *gpio_pingroup;
-	int i = 0, j;
+	int i, j;
 
 	if (!pmx->machdata->gpio_pingroups)
 		return NULL;
 
-	for (; i < pmx->machdata->ngpio_pingroups; i++) {
+	for (i = 0; i < pmx->machdata->ngpio_pingroups; i++) {
 		gpio_pingroup = &pmx->machdata->gpio_pingroups[i];
 
 		for (j = 0; j < gpio_pingroup->npins; j++) {
@@ -298,7 +298,7 @@ static struct spear_gpio_pingroup *get_gpio_pingroup(struct spear_pmx *pmx,
 		}
 	}
 
-	return ERR_PTR(-EINVAL);
+	return NULL;
 }
 
 static int gpio_request_endisable(struct pinctrl_dev *pctldev,
-- 
1.7.9.5



