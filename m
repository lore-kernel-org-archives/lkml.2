Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965308Ab2CMAhl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:37:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40694 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965003Ab2CMAYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:24:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-sh list" <linux-sh@vger.kernel.org>
Subject: [PATCH 5/6] PM / shmobile: Make CMT driver use pm_genpd_dev_always_on()
Date: Tue, 13 Mar 2012 01:27:07 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>, Paul Mundt <lethal@linux-sh.org>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Cao Minh Hiep <hiepcm@gmail.com>
References: <201203130123.16268.rjw@sisk.pl>
In-Reply-To: <201203130123.16268.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201203130127.07634.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make the CMT clocksource driver mark its device as "always on"
using pm_genpd_dev_always_on() to protect it from surprise power
removals.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/clocksource/sh_cmt.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux/drivers/clocksource/sh_cmt.c
===================================================================
--- linux.orig/drivers/clocksource/sh_cmt.c
+++ linux/drivers/clocksource/sh_cmt.c
@@ -32,6 +32,7 @@
 #include <linux/sh_timer.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/pm_domain.h>
 
 struct sh_cmt_priv {
 	void __iomem *mapbase;
@@ -689,6 +690,9 @@ static int __devinit sh_cmt_probe(struct
 	struct sh_cmt_priv *p = platform_get_drvdata(pdev);
 	int ret;
 
+	if (!is_early_platform_device(pdev))
+		pm_genpd_dev_always_on(&pdev->dev, true);
+
 	if (p) {
 		dev_info(&pdev->dev, "kept as earlytimer\n");
 		return 0;

