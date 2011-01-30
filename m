Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab1A3T35 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 14:29:57 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:62362 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab1A3T34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 14:29:56 -0500
From: Stefan Weil <weil@mail.berlios.de>
To: Tony Lindgren <tony@atomide.com>
Cc: Stefan Weil <weil@mail.berlios.de>, Russell King <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 19/23] arm: Fix possible null pointer read access
Date: Sun, 30 Jan 2011 20:29:38 +0100
Message-Id: <1296415778-4638-1-git-send-email-weil@mail.berlios.de>
X-Mailer: git-send-email 1.7.2.3
X-Provags-ID: V02:K0:aWDSUlRUAnN5IhHbaCxkje+O0LzTW6TrgCFv+GV44bH
 PQ/iT1RYPlLe3M7PX1verHyayNqCkfpk1XQYfd5dUoqbFgeGc5
 ukp2eWkGDVsy1a568uQg+PmHe/4tZU2MoJaaZ+EXhzCtUVGnPC
 6i1fikNtYFmb/TY91VkmFdm9ItQUuUzn++3JcW9/OkWRxAQPuX
 01Oy7AbFJ8Ei0abBqLwqodw6f3IswhZUUAXU8yx6NZqChDCsF/
 SuwHMSJrext3K
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These errors were found by cppcheck:
arch/arm/mach-omap2/smartreflex.c:784: error: Possible null pointer dereference: sr_info
arch/arm/mach-omap2/smartreflex.c:799: error: Possible null pointer dereference: sr_info

Both conditional statements are executed when sr_info == NULL,
so accessing sr_info->voltdm would fail.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-omap@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Stefan Weil <weil@mail.berlios.de>
---
 arch/arm/mach-omap2/smartreflex.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-omap2/smartreflex.c b/arch/arm/mach-omap2/smartreflex.c
index 77ecebf..af39d17 100644
--- a/arch/arm/mach-omap2/smartreflex.c
+++ b/arch/arm/mach-omap2/smartreflex.c
@@ -780,8 +780,7 @@ static int omap_sr_autocomp_show(void *data, u64 *val)
 	struct omap_sr *sr_info = (struct omap_sr *) data;

 	if (!sr_info) {
-		pr_warning("%s: omap_sr struct for sr_%s not found\n",
-			__func__, sr_info->voltdm->name);
+		pr_warning("%s: omap_sr struct not found\n", __func__);
 		return -EINVAL;
 	}

@@ -795,8 +794,7 @@ static int omap_sr_autocomp_store(void *data, u64 val)
 	struct omap_sr *sr_info = (struct omap_sr *) data;

 	if (!sr_info) {
-		pr_warning("%s: omap_sr struct for sr_%s not found\n",
-			__func__, sr_info->voltdm->name);
+		pr_warning("%s: omap_sr struct not found\n", __func__);
 		return -EINVAL;
 	}

--
1.7.2.3

