Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab2ILFaL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 01:30:11 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51549 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab2ILFaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 01:30:05 -0400
From: Damian Hobson-Garcia <dhobsong@igel.co.jp>
To: horms@verge.net.au, magnus.damm@gmail.com
Cc: hjk@hansjkoch.de, linux-sh@vger.kernel.org, hdk@igel.co.jp,
        linux-kernel@vger.kernel.org,
        Damian Hobson-Garcia <dhobsong@igel.co.jp>
Subject: [RFC PATCH 2/2] ARM: shmobile: sh7372: Change VPU UIO to uio_dmem_genirq
Date: Wed, 12 Sep 2012 14:29:45 +0900
Message-Id: <1347427785-9767-3-git-send-email-dhobsong@igel.co.jp>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1347427785-9767-1-git-send-email-dhobsong@igel.co.jp>
References: <1347427785-9767-1-git-send-email-dhobsong@igel.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows the VPU memory to be allocated dynamically only when it
is needed.

Signed-off-by: Damian Hobson-Garcia <dhobsong@igel.co.jp>
---
 arch/arm/mach-shmobile/setup-sh7372.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-shmobile/setup-sh7372.c b/arch/arm/mach-shmobile/setup-sh7372.c
index 1106b4f..fe75701 100644
--- a/arch/arm/mach-shmobile/setup-sh7372.c
+++ b/arch/arm/mach-shmobile/setup-sh7372.c
@@ -21,6 +21,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
+#include <linux/platform_data/uio_dmem_genirq.h>
 #include <linux/platform_device.h>
 #include <linux/of_platform.h>
 #include <linux/uio_driver.h>
@@ -761,11 +762,19 @@ static struct platform_device usb_dma1_device = {
 	},
 };
 
+static unsigned int region_sizes[] = {
+	(32 << 20),
+};
+
 /* VPU */
-static struct uio_info vpu_platform_data = {
-	.name = "VPU5HG",
-	.version = "0",
-	.irq = intcs_evt2irq(0x980),
+static struct uio_dmem_genirq_pdata vpu_platform_data = {
+	.uioinfo = {
+		.name = "VPU5HG",
+		.version = "0",
+		.irq = intcs_evt2irq(0x980),
+	},
+	.dynamic_region_sizes	= region_sizes,
+	.num_dynamic_regions	= ARRAY_SIZE(region_sizes),
 };
 
 static struct resource vpu_resources[] = {
@@ -778,7 +787,7 @@ static struct resource vpu_resources[] = {
 };
 
 static struct platform_device vpu_device = {
-	.name		= "uio_pdrv_genirq",
+	.name		= "uio_dmem_genirq",
 	.id		= 0,
 	.dev = {
 		.platform_data	= &vpu_platform_data,
-- 
1.7.5.4

