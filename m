Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab2G0WBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 18:01:18 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:60935 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752404Ab2G0WBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 18:01:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH] sh: pfc: Fix build issues in pinctrl.c
Date: Sat, 28 Jul 2012 00:07:04 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: "Linux-sh list" <linux-sh@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207280007.04480.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


First off, drivers/sh/pfc/pinctrl.c doesn't build after commit
5d589b0 (pinctrl: remove pinctrl_remove_gpio_range), because
sh_pfc_pinctrl_remove() uses the function that has been removed by
that commit.  Fix this by removing the pinctrl_remove_gpio_range()
call, which is not necessary any more, from sh_pfc_pinctrl_remove().

Second, the compiler complains correctly that there's an unused
local variable in sh_pfc_pinconf_set().  Fix this by removing the
definition of that variable.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/sh/pfc/pinctrl.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux/drivers/sh/pfc/pinctrl.c
===================================================================
--- linux.orig/drivers/sh/pfc/pinctrl.c
+++ linux/drivers/sh/pfc/pinctrl.c
@@ -276,7 +276,6 @@ static int sh_pfc_pinconf_set(struct pin
 			      unsigned long config)
 {
 	struct sh_pfc_pinctrl *pmx = pinctrl_dev_get_drvdata(pctldev);
-	struct sh_pfc *pfc = pmx->pfc;
 
 	/* Validate the new type */
 	if (config >= PINMUX_FLAG_TYPE)
@@ -481,7 +480,6 @@ static int __devexit sh_pfc_pinctrl_remo
 {
 	struct sh_pfc_pinctrl *pmx = platform_get_drvdata(pdev);
 
-	pinctrl_remove_gpio_range(pmx->pctl, &sh_pfc_gpio_range);
 	pinctrl_unregister(pmx->pctl);
 
 	platform_set_drvdata(pdev, NULL);
