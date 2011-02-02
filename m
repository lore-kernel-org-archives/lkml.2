Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab1BBAu3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:50:29 -0500
Received: from mga02.intel.com ([134.134.136.20]:31247 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866Ab1BBApH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:45:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="598622676"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: broonie@opensource.wolfsonmicro.com, sameo@linux.intel.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [118/139] mfd: Support additional parent IDs for wm831x
Message-Id: <20110202004517.464E53E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:45:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit b93cef556162b0f33399bfe5f307c54f51554e09 upstream.

Some newer device revisions add a second parent ID. Support this in
the device validity checks done at startup.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/mfd/wm831x-core.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/mfd/wm831x-core.c
===================================================================
--- linux-2.6.35.y.orig/drivers/mfd/wm831x-core.c
+++ linux-2.6.35.y/drivers/mfd/wm831x-core.c
@@ -1463,7 +1463,11 @@ static int wm831x_device_init(struct wm8
 		dev_err(wm831x->dev, "Failed to read parent ID: %d\n", ret);
 		goto err;
 	}
-	if (ret != 0x6204) {
+	switch (ret) {
+	case 0x6204:
+	case 0x6246:
+		break;
+	default:
 		dev_err(wm831x->dev, "Device is not a WM831x: ID %x\n", ret);
 		ret = -EINVAL;
 		goto err;
