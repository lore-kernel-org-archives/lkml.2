Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab1CLWkE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 17:40:04 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36427 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648Ab1CLWkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 17:40:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=Fk0rN/R6qDTChycVBfsw++RDqsFWuUHaMrO6HKrW9FY0uKVcMmn1dEv7uNCj8l/fHz
         YFY7NmvGiqE2PilW62mwsr4Jczo6DTMOEZziATkZCAjSthoz1wsnttWtd574e6lCW6T9
         IUEeZt6k5AEfMvq15aQ3glnfz2n1gIV+NF6y4=
From: Andy Green <andy@warmcat.com>
Subject: [RFC PATCH 1/3] USB HOST CORE:probed devices collect any
 platform_data waiting for them
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Cc: patches@linaro.org, Andy Green <andy.green@linaro.org>
Date: Sat, 12 Mar 2011 22:39:56 +0000
Message-ID: <20110312223956.27344.88916.stgit@otae.warmcat.com>
In-Reply-To: <20110312223643.27344.72406.stgit@otae.warmcat.com>
References: <20110312223643.27344.72406.stgit@otae.warmcat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This causes all usb devices created during USB probe to
check with the aysnc platform_data api to see if they should
get tagged with waiting platform data based on their device
path.

Signed-off-by: Andy Green <andy.green@linaro.org>
---

 drivers/usb/core/usb.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/core/usb.c b/drivers/usb/core/usb.c
index 079cb57..03d9049 100644
--- a/drivers/usb/core/usb.c
+++ b/drivers/usb/core/usb.c
@@ -36,6 +36,7 @@
 #include <linux/mutex.h>
 #include <linux/workqueue.h>
 #include <linux/debugfs.h>
+#include <linux/platform_device.h>
 
 #include <asm/io.h>
 #include <linux/scatterlist.h>
@@ -444,6 +445,8 @@ struct usb_device *usb_alloc_dev(struct usb_device *parent,
 	dev->parent = parent;
 	INIT_LIST_HEAD(&dev->filelist);
 
+	platform_async_platform_data_attach(&dev->dev);
+
 #ifdef	CONFIG_PM
 	pm_runtime_set_autosuspend_delay(&dev->dev,
 			usb_autosuspend_delay * 1000);

