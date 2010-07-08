Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758301Ab0GHBqL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 21:46:11 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:46249 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755640Ab0GHBqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 21:46:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=qD04avvNDRQe/RTmE1ItF4gokbWOxMLBMj7eI4O2j6YEo79EWqfFYJlhPMQ9eoTFzY
         1818FnKdr0AjXNWE1Qb/tWVXTGvf3Zrt+bkgiNYa/aIjWvXVbBtPbRJilzq/poVPaEuz
         nO+2Tw12jxTk8xrFGyGsym3dsT1wCrUcZhhRw=
Subject: [PATCH] acerhdf: make needlessly global symbols static
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Peter Feuerer <peter@piie.net>, Matthew Garrett <mjg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Borislav Petkov <petkovbb@gmail.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       platform-driver-x86@vger.kernel.org
Content-Type: text/plain
Date: Thu, 08 Jul 2010 09:46:20 +0800
Message-Id: <1278553580.7162.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following symbols are needlessly defined global:

thz_dev
cl_dev
acerhdf_dev
acerhdf_dev_ops
acerhdf_cooling_ops

This patch makes the symbols static.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/platform/x86/acerhdf.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index 7b2384d..5caaaf0 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -92,9 +92,9 @@ static unsigned int fanstate = ACERHDF_FAN_AUTO;
 static char force_bios[16];
 static char force_product[16];
 static unsigned int prev_interval;
-struct thermal_zone_device *thz_dev;
-struct thermal_cooling_device *cl_dev;
-struct platform_device *acerhdf_dev;
+static struct thermal_zone_device *thz_dev;
+static struct thermal_cooling_device *cl_dev;
+static struct platform_device *acerhdf_dev;
 
 module_param(kernelmode, uint, 0);
 MODULE_PARM_DESC(kernelmode, "Kernel mode fan control on / off");
@@ -374,7 +374,7 @@ static int acerhdf_get_crit_temp(struct thermal_zone_device *thermal,
 }
 
 /* bind callback functions to thermalzone */
-struct thermal_zone_device_ops acerhdf_dev_ops = {
+static struct thermal_zone_device_ops acerhdf_dev_ops = {
 	.bind = acerhdf_bind,
 	.unbind = acerhdf_unbind,
 	.get_temp = acerhdf_get_ec_temp,
@@ -449,7 +449,7 @@ err_out:
 }
 
 /* bind fan callbacks to fan device */
-struct thermal_cooling_device_ops acerhdf_cooling_ops = {
+static struct thermal_cooling_device_ops acerhdf_cooling_ops = {
 	.get_max_state = acerhdf_get_max_state,
 	.get_cur_state = acerhdf_get_cur_state,
 	.set_cur_state = acerhdf_set_cur_state,
-- 
1.5.4.3



