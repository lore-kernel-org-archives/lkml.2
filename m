Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab1HOOvz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 10:51:55 -0400
Received: from www.linutronix.de ([62.245.132.108]:45211 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600Ab1HOOvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 10:51:51 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: linux-usb@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Subject: [PATCH 01/20] drivers_base: platform: use always ->name for uevent
Date: Mon, 15 Aug 2011 16:51:22 +0200
Message-Id: <1313419901-13492-2-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1313419901-13492-1-git-send-email-bigeasy@linutronix.de>
References: <1313419901-13492-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If id_entry is available then it is used. However if we remove first the
driver followed by the device, then the id_entry is pointing to driver's
memory which is long gone.
Since id->name and plat->name are equal there is no point in
distinguishing them.

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/base/platform.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 0cad9c7..cd71575 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -614,7 +614,7 @@ static int platform_uevent(struct device *dev, struct kobj_uevent_env *env)
 		return rc;
 
 	add_uevent_var(env, "MODALIAS=%s%s", PLATFORM_MODULE_PREFIX,
-		(pdev->id_entry) ? pdev->id_entry->name : pdev->name);
+			pdev->name);
 	return 0;
 }
 
-- 
1.7.4.4

