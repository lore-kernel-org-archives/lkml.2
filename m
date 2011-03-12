Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab1CLWcd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 17:32:33 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54903 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756005Ab1CLWcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 17:32:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=gtfZF18QjlNHxS6e/BxRPaf2r45OBCHGNsrOSKQWdecsOPwjHttMn6AV9uOWSYCBk+
         28sFBc/zBegB/QfYMPy1JfBv4DncuUMBAEbqBek6U0d7BrV0A9TMPlhLfnmEzKNgGdjd
         nnOfKGqLKj9W9rVLg7tZCRKCxsCDY2B9onovI=
From: Andy Green <andy@warmcat.com>
Subject: [RFC PATCH 1/4] PLATFORM: introduce structure to bind async platform
 data to a dev path name
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Cc: patches@linaro.org, Andy Green <andy.green@linaro.org>
Date: Sat, 12 Mar 2011 22:32:12 +0000
Message-ID: <20110312223212.27020.9839.stgit@otae.warmcat.com>
In-Reply-To: <20110312222633.27020.19543.stgit@otae.warmcat.com>
References: <20110312222633.27020.19543.stgit@otae.warmcat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This structure allows tagging arbitrary platform_data that can't be attached
to a device until after it is probed, with the device path name that it is
to be attached to.

Signed-off-by: Andy Green <andy.green@linaro.org>
---

 include/linux/platform_device.h |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index 2e700ec..d8c0ba9 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -193,4 +193,21 @@ static inline char *early_platform_driver_setup_func(void)		\
 }
 #endif /* MODULE */
 
+/**
+ * platform_async_platform_data - maps a known bus + device name on to
+ *				  platform_data to be attached to that device
+ *				  when it is eventually instantiated.  For use
+ *				  with onboard devices on buses that probe
+ *				  asynchronously.  Device path fields must
+ *				  be separated with '/'.
+ * @device_path:	bus / device path, eg, "usb1/1-1/1-1.1"
+ * @platform_data:	platform_data to attach to device matching the
+ *			device_path
+ */
+
+struct platform_async_platform_data {
+	const char *device_path;
+	void *platform_data;
+};
+
 #endif /* _PLATFORM_DEVICE_H_ */

