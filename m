Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642Ab2J1Xnn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:43:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41945 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756236Ab2J1X1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:27:30 -0400
Message-Id: <20121028231606.861699734@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:17:12 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jan Luebbe <jlu@pengutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Roland Stigge <stigge@antcom.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 096/105] drivers/rtc/rtc-imxdi.c: add missing spin lock initialization
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Luebbe <jlu@pengutronix.de>

commit fee0de7791f967c2c5f0d43eb7b7261761b45e64 upstream.

Signed-off-by: Jan Luebbe <jlu@pengutronix.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Roland Stigge <stigge@antcom.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
Tested-by: Roland Stigge <stigge@antcom.de>
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/rtc/rtc-imxdi.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/rtc/rtc-imxdi.c b/drivers/rtc/rtc-imxdi.c
index 891cd6c..4eed510 100644
--- a/drivers/rtc/rtc-imxdi.c
+++ b/drivers/rtc/rtc-imxdi.c
@@ -392,6 +392,8 @@ static int dryice_rtc_probe(struct platform_device *pdev)
 	if (imxdi->ioaddr == NULL)
 		return -ENOMEM;
 
+	spin_lock_init(&imxdi->irq_lock);
+
 	imxdi->irq = platform_get_irq(pdev, 0);
 	if (imxdi->irq < 0)
 		return imxdi->irq;


