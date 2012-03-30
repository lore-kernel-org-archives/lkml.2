Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936082Ab2C3Vbb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:31:31 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53362 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964829Ab2C3VbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:31:21 -0400
X-Sasl-enc: Qackn1kCtrFMPVGxVvasQYGkUAoug1EE5ROAQfCbTBmP 1333143080
X-Mailbox-Line: From gregkh@linuxfoundation.org Fri Mar 30 12:48:52 2012
Message-Id: <20120330194852.372997913@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:50:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Simon Horman <horms@verge.net.au>, Paul Mundt <lethal@linux-sh.org>
Subject: [ 130/175] PM / shmobile: Make CMT driver use pm_genpd_dev_always_on()
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Rafael J. Wysocki <rjw@sisk.pl>

Commit 615a445f7f8a077c145e737864ae59a4d8717882 upstream.

Make the CMT clocksource driver mark its device as "always on"
using pm_genpd_dev_always_on() to protect it from surprise power
removals.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Tested-by: Simon Horman <horms@verge.net.au>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clocksource/sh_cmt.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/clocksource/sh_cmt.c
+++ b/drivers/clocksource/sh_cmt.c
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


