Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645Ab2JIGH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:07:26 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:49201 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab2JIGDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:03:13 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH 17/30] Fix a build error.
Date: Tue,  9 Oct 2012 01:54:07 -0400
Message-Id: <a7a3b8c86f9fb8e8d13fb51a4a8b68166893b9b5.1349761836.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.0.rc1
In-Reply-To: <1349762060-25334-1-git-send-email-lenb@kernel.org>
References: <1349762060-25334-1-git-send-email-lenb@kernel.org>
In-Reply-To: <e3f25e6e5836c4790fbe395ff42e241f372d859d.1349761836.git.len.brown@intel.com>
References: <e3f25e6e5836c4790fbe395ff42e241f372d859d.1349761836.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eduardo Valentin <eduardo.valentin@ti.com>

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/staging/omap-thermal/omap-thermal-common.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/omap-thermal/omap-thermal-common.c b/drivers/staging/omap-thermal/omap-thermal-common.c
index d543d5c..b4cd6cc 100644
--- a/drivers/staging/omap-thermal/omap-thermal-common.c
+++ b/drivers/staging/omap-thermal/omap-thermal-common.c
@@ -120,7 +120,9 @@ static int omap_thermal_bind(struct thermal_zone_device *thermal,
 
 	/* TODO: bind with min and max states */
 	/* Simple thing, two trips, one passive another critical */
-	return thermal_zone_bind_cooling_device(thermal, 0, cdev);
+	return thermal_zone_bind_cooling_device(thermal, 0, cdev,
+						THERMAL_NO_LIMIT,
+						THERMAL_NO_LIMIT);
 }
 
 /* Unbind callback functions for thermal zone */
-- 
1.8.0.rc1

