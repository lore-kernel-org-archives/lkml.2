Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936090Ab0GPJF2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 05:05:28 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:47560 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936052Ab0GPJF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 05:05:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=ddTp5FSPf0/m2zCajwhPMNCFWWGshhHbNPMLGiKZ/u9B3zAgLR2Vv6tZTyicF+U9a4
         TfV3vRLGio0Vky9Ij9wDMdq5btT+EaxWoH4KK1jMQyU+qJGvTgN8IYnA6e4zaLA3NDL4
         cKA3V+KqM3p33aS9loOwxuPIWDIIkWlIN2yBY=
Message-ID: <4C4020C7.2060001@gmail.com>
Date: Fri, 16 Jul 2010 17:05:11 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH] ARM/nuc900: add nuc900 keypad arch platform data
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is to add nuc900 keypad arch platform data.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>

---
 arch/arm/mach-w90x900/dev.c |   37 +++++++++++++++++++++++++++++++++++++
 1 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-w90x900/dev.c b/arch/arm/mach-w90x900/dev.c
index 73b3eca..7ae5438 100644
--- a/arch/arm/mach-w90x900/dev.c
+++ b/arch/arm/mach-w90x900/dev.c
@@ -37,6 +37,7 @@
 #include <mach/map.h>
 #include <mach/fb.h>
 #include <mach/regs-ldm.h>
+#include <mach/w90p910_keypad.h>

 #include "cpu.h"

@@ -362,6 +363,39 @@ struct platform_device nuc900_device_fmi = {

 /* KPI controller*/

+static int nuc900_keymap[] = {
+	KEY(0, 0, KEY_A),
+	KEY(0, 1, KEY_B),
+	KEY(0, 2, KEY_C),
+	KEY(0, 3, KEY_D),
+
+	KEY(1, 0, KEY_E),
+	KEY(1, 1, KEY_F),
+	KEY(1, 2, KEY_G),
+	KEY(1, 3, KEY_H),
+
+	KEY(2, 0, KEY_I),
+	KEY(2, 1, KEY_J),
+	KEY(2, 2, KEY_K),
+	KEY(2, 3, KEY_L),
+
+	KEY(3, 0, KEY_M),
+	KEY(3, 1, KEY_N),
+	KEY(3, 2, KEY_O),
+	KEY(3, 3, KEY_P),
+};
+
+static struct matrix_keymap_data nuc900_map_data = {
+	.keymap			= nuc900_keymap,
+	.keymap_size		= ARRAY_SIZE(nuc900_keymap),
+};
+
+struct w90p910_keypad_platform_data nuc900_keypad_info = {
+	.keymap_data	= &nuc900_map_data,
+	.prescale	= 0xfa,
+	.debounce	= 0x50,
+};
+
 static struct resource nuc900_kpi_resource[] = {
 	[0] = {
 		.start = W90X900_PA_KPI,
@@ -381,6 +415,9 @@ struct platform_device nuc900_device_kpi = {
 	.id		= -1,
 	.num_resources	= ARRAY_SIZE(nuc900_kpi_resource),
 	.resource	= nuc900_kpi_resource,
+	.dev		= {
+				.platform_data = &nuc900_keypad_info,
+			}
 };

 /* LCD controller*/
-- 
1.6.3.3
