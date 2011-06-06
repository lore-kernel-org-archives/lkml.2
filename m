Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050Ab1FFUwf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 16:52:35 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:54626 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757302Ab1FFUwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 16:52:34 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-131.messagelabs.com!1307393517!17081451!43
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.98]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] gpio: vr41xx_giu: use resource_size()
Date: Mon, 6 Jun 2011 13:52:19 -0700
User-Agent: KMail/1.9.9
CC: <grant.likely@secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201106061352.19881.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Grant Likely <grant.likely@secretlab.ca>

---

diff --git a/drivers/gpio/vr41xx_giu.c b/drivers/gpio/vr41xx_giu.c
index a365be0..98723cb 100644
--- a/drivers/gpio/vr41xx_giu.c
+++ b/drivers/gpio/vr41xx_giu.c
@@ -518,7 +518,7 @@ static int __devinit giu_probe(struct platform_device *pdev)
 	if (!res)
 		return -EBUSY;
 
-	giu_base = ioremap(res->start, res->end - res->start + 1);
+	giu_base = ioremap(res->start, resource_size(res));
 	if (!giu_base)
 		return -ENOMEM;
 
