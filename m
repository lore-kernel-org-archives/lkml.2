Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606Ab2IJIyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 04:54:43 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:45294 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071Ab2IJIuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 04:50:55 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqcCAHGoTVBbdWObgWdsb2JhbABFhUBHtUoiAQEWJieCIAEBBSMECwFGECAFAiYCAlcGE4gUqBWSO4EhjxaBEgOVXZMF
X-IronPort-AV: E=Sophos;i="4.80,397,1344204000"; 
   d="scan'208";a="949262493"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
Subject: [PATCH 05/20] Staging: ipack: Choose the optimum bus speed by default.
Date: Mon, 10 Sep 2012 10:51:43 +0200
Message-Id: <1347267118-9580-5-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347267118-9580-1-git-send-email-siglesias@igalia.com>
References: <1347267118-9580-1-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
---
 drivers/staging/ipack/ipack.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/staging/ipack/ipack.c b/drivers/staging/ipack/ipack.c
index 521ff55..6e0b441 100644
--- a/drivers/staging/ipack/ipack.c
+++ b/drivers/staging/ipack/ipack.c
@@ -386,6 +386,11 @@ struct ipack_device *ipack_device_register(struct ipack_bus_device *bus,
 		return NULL;
 	}
 
+	/* if the device supports 32 MHz operation, use it. */
+	ret = bus->ops->set_clockrate(dev, dev->speed_32mhz ? 32 : 8);
+	if (ret < 0)
+		dev_err(&dev->dev, "failed to switch to 32 MHz operation.\n");
+
 	ret = device_register(&dev->dev);
 	if (ret < 0) {
 		kfree(dev->id);
-- 
1.7.10.4

