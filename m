Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933213Ab2JKAhQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:37:16 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36489 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933078Ab2JKAW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:22:57 -0400
X-Sasl-enc: ReaBuFUeaSvoYHwLQGDYZkDIB/KTHkNI4rc9VD1bL5YD 1349914976
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Chris Ball <cjb@laptop.org>
Subject: [ 117/122] mmc: slot-gpio: Fix missing assignment to ctx->ro_gpio
Date: Thu, 11 Oct 2012 07:54:43 +0900
Message-Id: <20121010225359.026616155@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010225337.989799482@linuxfoundation.org>
References: <20121010225337.989799482@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Ball <cjb@laptop.org>

commit 15e8a8e42966162c207bb97ed55c803bc437eeae upstream.

mmc_gpio_request_ro() doesn't store the requested gpio in ctx->ro_gpio.
As a result, subsequent calls to mmc_gpio_get_ro() will always fail
with -ENOSYS because the gpio number isn't available to that function.

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/core/slot-gpio.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/mmc/core/slot-gpio.c
+++ b/drivers/mmc/core/slot-gpio.c
@@ -100,7 +100,13 @@ int mmc_gpio_request_ro(struct mmc_host
 
 	ctx = host->slot.handler_priv;
 
-	return gpio_request_one(gpio, GPIOF_DIR_IN, ctx->ro_label);
+	ret = gpio_request_one(gpio, GPIOF_DIR_IN, ctx->ro_label);
+	if (ret < 0)
+		return ret;
+
+	ctx->ro_gpio = gpio;
+
+	return 0;
 }
 EXPORT_SYMBOL(mmc_gpio_request_ro);
 


