Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab1BBApK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:45:10 -0500
Received: from mga02.intel.com ([134.134.136.20]:35533 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753869Ab1BBApI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:45:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="598622684"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: broonie@opensource.wolfsonmicro.com, sameo@linux.intel.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [119/139] mfd: Supply IRQ base for WM832x devices
Message-Id: <20110202004518.50DD63E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:45:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit bd7c72ed18d719c1fb0fdf6ff9042d8ab78fdf71 upstream.

Without this the IRQ base will not be correctly configured for the
subdevices.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/mfd/wm831x-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/mfd/wm831x-core.c
===================================================================
--- linux-2.6.35.y.orig/drivers/mfd/wm831x-core.c
+++ linux-2.6.35.y/drivers/mfd/wm831x-core.c
@@ -1608,7 +1608,7 @@ static int wm831x_device_init(struct wm8
 	case WM8320:
 		ret = mfd_add_devices(wm831x->dev, -1,
 				      wm8320_devs, ARRAY_SIZE(wm8320_devs),
-				      NULL, 0);
+				      NULL, wm831x->irq_base);
 		break;
 
 	default:
