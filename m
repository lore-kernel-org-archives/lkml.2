Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759252Ab2IKLeo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 07:34:44 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:26724 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759206Ab2IKLel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 07:34:41 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Au8CAIAhT1BbdWObgWdsb2JhbABFhUBHtUkiAQEWJieCIAEBBSMECwFGECAFAiYCAlcGE4gUqGiTN4EhjwOBEgOVXZMF
X-IronPort-AV: E=Sophos;i="4.80,404,1344204000"; 
   d="scan'208";a="564505322"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
Subject: [PATCH v2 05/20] Staging: ipack: Choose the optimum bus speed by default.
Date: Tue, 11 Sep 2012 13:34:58 +0200
Message-Id: <1347363313-17094-6-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347363313-17094-1-git-send-email-siglesias@igalia.com>
References: <1347363313-17094-1-git-send-email-siglesias@igalia.com>
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
index c36ba9e..1ad73e5 100644
--- a/drivers/staging/ipack/ipack.c
+++ b/drivers/staging/ipack/ipack.c
@@ -387,6 +387,11 @@ struct ipack_device *ipack_device_register(struct ipack_bus_device *bus,
 		return NULL;
 	}
 
+	/* if the device supports 32 MHz operation, use it. */
+	ret = bus->ops->set_clockrate(dev, dev->speed_32mhz ? 32 : 8);
+	if (ret < 0)
+		dev_err(&dev->dev, "failed to perform set_clock_rate operation.\n");
+
 	ret = device_register(&dev->dev);
 	if (ret < 0) {
 		kfree(dev->id);
-- 
1.7.10.4

