Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337Ab2IKLih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 07:38:37 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:43407 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759212Ab2IKLem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 07:34:42 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsgCAIAhT1BbdWObgWdsb2JhbABFhge1SSIBARYmJ4IgAQEFIwQLAUYQIAUCJgICVwYTiBSoaJM3gSGPA4ESA5VdkwU
X-IronPort-AV: E=Sophos;i="4.80,404,1344204000"; 
   d="scan'208";a="564505353"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
Subject: [PATCH v2 09/20] Staging: ipack: reset previous timeouts during device registration.
Date: Tue, 11 Sep 2012 13:35:02 +0200
Message-Id: <1347363313-17094-10-git-send-email-siglesias@igalia.com>
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

Resetting the previous timeout we avoid to read the timeout status register
and see timeout errors that don't correspond to the present state of the
device.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
---
 drivers/staging/ipack/ipack.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/ipack/ipack.c b/drivers/staging/ipack/ipack.c
index e2f819c..08b122d 100644
--- a/drivers/staging/ipack/ipack.c
+++ b/drivers/staging/ipack/ipack.c
@@ -379,6 +379,8 @@ struct ipack_device *ipack_device_register(struct ipack_bus_device *bus,
 
 	if (bus->ops->set_clockrate(dev, 8))
 		dev_warn(&dev->dev, "failed to switch to 8 MHz operation for reading of device ID.\n");
+	if (bus->ops->reset_timeout(dev))
+		dev_warn(&dev->dev, "failed to reset potential timeout.");
 
 	ret = ipack_device_read_id(dev);
 	if (ret < 0) {
-- 
1.7.10.4

