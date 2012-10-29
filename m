Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760678Ab2J2USI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 16:18:08 -0400
Received: from mail.kernel.org ([198.145.19.201]:42533 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760586Ab2J2UIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 16:08:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jan Luebbe <jlu@pengutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Roland Stigge <stigge@antcom.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 03/34] drivers/rtc/rtc-imxdi.c: add missing spin lock initialization
Date: Mon, 29 Oct 2012 13:07:34 -0700
Message-Id: <20121029200420.959210447@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029200420.550338074@linuxfoundation.org>
References: <20121029200420.550338074@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rtc/rtc-imxdi.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/rtc/rtc-imxdi.c
+++ b/drivers/rtc/rtc-imxdi.c
@@ -391,6 +391,8 @@ static int dryice_rtc_probe(struct platf
 	if (imxdi->ioaddr == NULL)
 		return -ENOMEM;
 
+	spin_lock_init(&imxdi->irq_lock);
+
 	imxdi->irq = platform_get_irq(pdev, 0);
 	if (imxdi->irq < 0)
 		return imxdi->irq;


