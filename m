Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab0GMJSg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 05:18:36 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47362 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab0GMJSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 05:18:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=ThPmsU/vmXQcIs7qnMnNDeIWqVaPLmnWqRggNtPPVJLh7dRlsksbhJEjGhN2SUA/I+
         WxOGektCFRGOr8G5Ptb5qB/U2d3PxExSRIgAHKPnxUJDDUnGKWgC+Koo/nGVC92EqcfQ
         +wVu4F7KWZPYd7uptbp+Go1nvGw1iq4EoAER0=
Subject: [PATCH] atlas_btns: adds a missing owner field for
	atlas_acpi_driver
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Len Brown <len.brown@intel.com>, Lin Ming <ming.m.lin@intel.com>,
        linux-input@vger.kernel.org
Content-Type: text/plain
Date: Tue, 13 Jul 2010 17:13:24 +0800
Message-Id: <1279012404.28550.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The owner field provides the link between drivers and modules in sysfs.
After setting the owner field, we can see which module provides which
driver and vice versa by looking at /sys/bus/acpi/drivers/Atlas ACPI/module
and /sys/module/atlas_btns/drivers/acpi:Atlas ACPI

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/input/misc/atlas_btns.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/input/misc/atlas_btns.c b/drivers/input/misc/atlas_btns.c
index dfaa9a0..7d53608 100644
--- a/drivers/input/misc/atlas_btns.c
+++ b/drivers/input/misc/atlas_btns.c
@@ -145,6 +145,7 @@ MODULE_DEVICE_TABLE(acpi, atlas_device_ids);
 static struct acpi_driver atlas_acpi_driver = {
 	.name	= ACPI_ATLAS_NAME,
 	.class	= ACPI_ATLAS_CLASS,
+	.owner	= THIS_MODULE,
 	.ids	= atlas_device_ids,
 	.ops	= {
 		.add	= atlas_acpi_button_add,
-- 
1.5.4.3



