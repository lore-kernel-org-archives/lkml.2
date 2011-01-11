Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117Ab1AKMpi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 07:45:38 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51682 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755997Ab1AKMou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 07:44:50 -0500
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: Jamie Iles <jamie@jamieiles.com>, netdev@vger.kernel.org
Subject: [PATCH 14/16] can: mpc5xxx_can: don't treat NULL clk as an error
Date: Tue, 11 Jan 2011 12:43:51 +0000
Message-Id: <1294749833-32019-15-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1294749833-32019-1-git-send-email-jamie@jamieiles.com>
References: <1294749833-32019-1-git-send-email-jamie@jamieiles.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clk_get() returns a struct clk cookie to the driver and some platforms
may return NULL if they only support a single clock.  clk_get() has only
failed if it returns a ERR_PTR() encoded pointer.

Cc: netdev@vger.kernel.org
Signed-off-by: Jamie Iles <jamie@jamieiles.com>
---
 drivers/net/can/mscan/mpc5xxx_can.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/mscan/mpc5xxx_can.c b/drivers/net/can/mscan/mpc5xxx_can.c
index 312b9c8..15377c0 100644
--- a/drivers/net/can/mscan/mpc5xxx_can.c
+++ b/drivers/net/can/mscan/mpc5xxx_can.c
@@ -29,6 +29,7 @@
 #include <linux/of_platform.h>
 #include <sysdev/fsl_soc.h>
 #include <linux/clk.h>
+#include <linux/err.h>
 #include <linux/io.h>
 #include <asm/mpc52xx.h>
 
@@ -181,7 +182,7 @@ static u32 __devinit mpc512x_can_get_clock(struct platform_device *ofdev,
 
 		if (!clock_name || !strcmp(clock_name, "sys")) {
 			sys_clk = clk_get(&ofdev->dev, "sys_clk");
-			if (!sys_clk) {
+			if (IS_ERR(sys_clk)) {
 				dev_err(&ofdev->dev, "couldn't get sys_clk\n");
 				goto exit_unmap;
 			}
@@ -204,7 +205,7 @@ static u32 __devinit mpc512x_can_get_clock(struct platform_device *ofdev,
 
 		if (clocksrc < 0) {
 			ref_clk = clk_get(&ofdev->dev, "ref_clk");
-			if (!ref_clk) {
+			if (IS_ERR(ref_clk)) {
 				dev_err(&ofdev->dev, "couldn't get ref_clk\n");
 				goto exit_unmap;
 			}
-- 
1.7.3.4

