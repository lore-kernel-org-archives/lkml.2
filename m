Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab0KZJkO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 04:40:14 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46265 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771Ab0KZJkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 04:40:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:date:subject:mime-version:x-tuid:x-uid:x-length
         :organization:to:cc:content-type:message-id;
        b=PH4Msp+XfJG6TAXZPTOHgEOcxiai7bpL07B8nlw9j6Ss0a0d0+1gGyltLXeB94r1GE
         IbJzD9KkPVrEraloFlVBBx/f2VUROSbak7SYv4ugZmYDnUoNY/rxlX/yrqVTQ4MKOS73
         GZOK0XYWOjAM2aIFgYOBVa5Z8mu0ODibVdEEw=
From: Florian Fainelli <florian@openwrt.org>
Date: Fri, 26 Nov 2010 10:39:55 +0100
Subject: [PATCH 2/2] rdc321x-wtd: fix null pointer dereference while accessing platform_data
MIME-Version: 1.0
X-TUID: f6b998f53b51d387
X-Length: 1603
Organization: OpenWrt
To: sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_rB47MSWUdoIYok5"
Message-Id: <201011261039.55953.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--Boundary-00=_rB47MSWUdoIYok5
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit

rdc321x-wdt currently fetches its driver specific data by using the platform_
device->platform_data pointer, this is wrong because the mfd device which
registers our platform_device has been added using mfd_add_device() which sets
the platform_device->driver_data pointer instead.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
CC: stable@kernel.org
---
This patch should be applied for the next 2.6.36 stable release.

diff --git a/drivers/watchdog/rdc321x_wdt.c b/drivers/watchdog/rdc321x_wdt.c
index 428f8a1..3939e53 100644
--- a/drivers/watchdog/rdc321x_wdt.c
+++ b/drivers/watchdog/rdc321x_wdt.c
@@ -231,7 +231,7 @@ static int __devinit rdc321x_wdt_probe(struct platform_device *pdev)
 	struct resource *r;
 	struct rdc321x_wdt_pdata *pdata;
 
-	pdata = pdev->dev.platform_data;
+	pdata = platform_get_drvdata(pdev);
 	if (!pdata) {
 		dev_err(&pdev->dev, "no platform data supplied\n");
 		return -ENODEV;

--Boundary-00=_rB47MSWUdoIYok5
Content-Type: text/x-patch;
  name="e28c923a79c0547fcbaa0bd3d5007c111d9b485f.diff"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline; filename="e28c923a79c0547fcbaa0bd3d5007c111d9b485f.diff"

diff --git a/drivers/watchdog/rdc321x_wdt.c b/drivers/watchdog/rdc321x_wdt.c
index 428f8a1..3939e53 100644
--- a/drivers/watchdog/rdc321x_wdt.c
+++ b/drivers/watchdog/rdc321x_wdt.c
@@ -231,7 +231,7 @@ static int __devinit rdc321x_wdt_probe(struct platform_device *pdev)
 	struct resource *r;
 	struct rdc321x_wdt_pdata *pdata;
 
-	pdata = pdev->dev.platform_data;
+	pdata = platform_get_drvdata(pdev);
 	if (!pdata) {
 		dev_err(&pdev->dev, "no platform data supplied\n");
 		return -ENODEV;

--Boundary-00=_rB47MSWUdoIYok5--



