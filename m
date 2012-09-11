Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212Ab2IKLjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 07:39:55 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:26724 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759138Ab2IKLei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 07:34:38 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsgCAIAhT1BbdWObgWdsb2JhbABFhge1SSIBARYmJ4IgAQEFIw8BNBIQIAUCJgICVwYTiBSoaJM3gSGPA4ESA5VdkwU
X-IronPort-AV: E=Sophos;i="4.80,404,1344204000"; 
   d="scan'208";a="564505290"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
Subject: [PATCH v2 02/20] Staging: ipack: Provide several carrier callbacks.
Date: Tue, 11 Sep 2012 13:34:55 +0200
Message-Id: <1347363313-17094-3-git-send-email-siglesias@igalia.com>
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

We provide callbacks to:
 - set/get the clockrate a module is accessed at,
 - get the error state of a slot,
 - get/reset the timeout state of a slot.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
---
 drivers/staging/ipack/ipack.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/staging/ipack/ipack.h b/drivers/staging/ipack/ipack.h
index 4d73f75..a133304 100644
--- a/drivers/staging/ipack/ipack.h
+++ b/drivers/staging/ipack/ipack.h
@@ -113,6 +113,15 @@ struct ipack_driver {
  *	@request_irq: request IRQ
  *	@free_irq: free IRQ
  *	@remove_device: tell the bridge module that the device has been removed
+ *	@get_clockrate: Returns the clockrate the carrier is currently
+ *		communicating with the device at.
+ *	@set_clockrate: Sets the clock-rate for carrier / module communication.
+ *		Should return -EINVAL if the requested speed is not supported.
+ *	@get_error: Returns the error state for the slot the device is attached
+ *		to.
+ *	@get_timeout: Returns 1 if the communication with the device has
+ *		previously timed out.
+ *	@reset_timeout: Resets the state returned by get_timeout.
  */
 struct ipack_bus_ops {
 	int (*map_space) (struct ipack_device *dev, unsigned int memory_size, int space);
@@ -120,6 +129,12 @@ struct ipack_bus_ops {
 	int (*request_irq) (struct ipack_device *dev, int vector, int (*handler)(void *), void *arg);
 	int (*free_irq) (struct ipack_device *dev);
 	int (*remove_device) (struct ipack_device *dev);
+
+	int (*get_clockrate) (struct ipack_device *dev);
+	int (*set_clockrate) (struct ipack_device *dev, int mherz);
+	int (*get_error) (struct ipack_device *dev);
+	int (*get_timeout) (struct ipack_device *dev);
+	int (*reset_timeout) (struct ipack_device *dev);
 };
 
 /**
-- 
1.7.10.4

