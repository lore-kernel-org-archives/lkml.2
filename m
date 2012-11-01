Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758935Ab2JaRZE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:25:04 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:57331 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758830Ab2JaRZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:25:01 -0400
From: Pantelis Antoniou <panto@antoniou-consulting.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        linux-kernel@vger.kernel.org, Koen Kooi <koen@dominion.thruhere.net>,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        linux-omap@vger.kernel.org
Subject: [PATCH 1/3] omap-device: Remove __init from omap_device_build family functions
Date: Thu,  1 Nov 2012 17:18:00 +0200
Message-Id: <1351783082-11411-2-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1351783082-11411-1-git-send-email-panto@antoniou-consulting.com>
References: <1351783082-11411-1-git-send-email-panto@antoniou-consulting.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marking omap_device_build && omap_device_build_ss as __init is
really bad when you want to instantiate a device later in the
boot sequence, or from a module.

Removing them makes the crashes go away.

Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
---
 arch/arm/plat-omap/omap_device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/plat-omap/omap_device.c b/arch/arm/plat-omap/omap_device.c
index 7a7d1f2..cf9a18d 100644
--- a/arch/arm/plat-omap/omap_device.c
+++ b/arch/arm/plat-omap/omap_device.c
@@ -663,7 +663,7 @@ void omap_device_delete(struct omap_device *od)
  * information.  Returns ERR_PTR(-EINVAL) if @oh is NULL; otherwise,
  * passes along the return value of omap_device_build_ss().
  */
-struct platform_device __init *omap_device_build(const char *pdev_name, int pdev_id,
+struct platform_device *omap_device_build(const char *pdev_name, int pdev_id,
 				      struct omap_hwmod *oh, void *pdata,
 				      int pdata_len,
 				      struct omap_device_pm_latency *pm_lats,
@@ -696,7 +696,7 @@ struct platform_device __init *omap_device_build(const char *pdev_name, int pdev
  * platform_device record.  Returns an ERR_PTR() on error, or passes
  * along the return value of omap_device_register().
  */
-struct platform_device __init *omap_device_build_ss(const char *pdev_name, int pdev_id,
+struct platform_device *omap_device_build_ss(const char *pdev_name, int pdev_id,
 					 struct omap_hwmod **ohs, int oh_cnt,
 					 void *pdata, int pdata_len,
 					 struct omap_device_pm_latency *pm_lats,
-- 
1.7.12

