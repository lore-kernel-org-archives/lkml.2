Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936261Ab2C3Vod (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:44:33 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41141 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965151Ab2C3VbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:31:22 -0400
X-Sasl-enc: 7xT6+Ujk1JlVcFp2GwTlBqy3SGykwimtUn4VFxSQasd2 1333143081
X-Mailbox-Line: From gregkh@linuxfoundation.org Fri Mar 30 12:48:52 2012
Message-Id: <20120330194852.601114116@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:50:36 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Simon Horman <horms@verge.net.au>, Paul Mundt <lethal@linux-sh.org>
Subject: [ 131/175] PM / shmobile: Make MTU2 driver use pm_genpd_dev_always_on()
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Rafael J. Wysocki <rjw@sisk.pl>

Commit 57d13370cfaf6017c68981e66ff5b3bf20a2705c upstream.

Make the MTU2 clocksource driver mark its device as "always on"
using pm_genpd_dev_always_on() to protect it from surprise power
removals.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Tested-by: Simon Horman <horms@verge.net.au>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clocksource/sh_mtu2.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/clocksource/sh_mtu2.c
+++ b/drivers/clocksource/sh_mtu2.c
@@ -31,6 +31,7 @@
 #include <linux/sh_timer.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/pm_domain.h>
 
 struct sh_mtu2_priv {
 	void __iomem *mapbase;
@@ -306,6 +307,9 @@ static int __devinit sh_mtu2_probe(struc
 	struct sh_mtu2_priv *p = platform_get_drvdata(pdev);
 	int ret;
 
+	if (!is_early_platform_device(pdev))
+		pm_genpd_dev_always_on(&pdev->dev, true);
+
 	if (p) {
 		dev_info(&pdev->dev, "kept as earlytimer\n");
 		return 0;


