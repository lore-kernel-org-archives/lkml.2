Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965Ab0GGGGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 02:06:16 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60334 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab0GGGGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 02:06:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=MdC2GNtW2QBk2ZCJdT3Atz6iaIE997uuSbhlIHyeLFDkLzIFOa4ENC7znPAh+SlP2e
         bezgAhpWx5shhTdrH3+5EskYdfGKmLCJehgjKvlrdgPPGJbyKOAhukT5/Gfc7KOEWLCD
         Al+NRZEHTjvmDpu0uNCFgwoKe08c5e3MIeQ+c=
Subject: [PATCH 2/2] toshiba_acpi: rename add_device() and remove_device()
	to create_toshiba_proc_entries() and remove_toshiba_proc_entries()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Matthew Garrett <mjg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       =?ISO-8859-1?Q?M=E1rton_N=E9meth?= <nm127@freemail.hu>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       platform-driver-x86@vger.kernel.org
In-Reply-To: <1278482630.12801.30.camel@mola>
References: <1278482630.12801.30.camel@mola>
Content-Type: text/plain
Date: Wed, 07 Jul 2010 14:06:25 +0800
Message-Id: <1278482785.12801.33.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To improve readability.
This patch rename add_device() to create_toshiba_proc_entries()
and rename remove_device() to remove_toshiba_proc_entries().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/platform/x86/toshiba_acpi.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 702869a..339a402 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -720,7 +720,7 @@ static const struct file_operations version_proc_fops = {
 
 #define PROC_TOSHIBA		"toshiba"
 
-static void __init add_device(void)
+static void __init create_toshiba_proc_entries(void)
 {
 	proc_create("lcd", S_IRUGO | S_IWUSR, toshiba_proc_dir, &lcd_proc_fops);
 	proc_create("video", S_IRUGO | S_IWUSR, toshiba_proc_dir, &video_proc_fops);
@@ -729,7 +729,7 @@ static void __init add_device(void)
 	proc_create("version", S_IRUGO, toshiba_proc_dir, &version_proc_fops);
 }
 
-static void remove_device(void)
+static void remove_toshiba_proc_entries(void)
 {
 	remove_proc_entry("lcd", toshiba_proc_dir);
 	remove_proc_entry("video", toshiba_proc_dir);
@@ -903,7 +903,7 @@ static void toshiba_acpi_exit(void)
 	if (toshiba_backlight_device)
 		backlight_device_unregister(toshiba_backlight_device);
 
-	remove_device();
+	remove_toshiba_proc_entries();
 
 	if (toshiba_proc_dir)
 		remove_proc_entry(PROC_TOSHIBA, acpi_root_dir);
@@ -965,7 +965,7 @@ static int __init toshiba_acpi_init(void)
 		toshiba_acpi_exit();
 		return -ENODEV;
 	} else {
-		add_device();
+		create_toshiba_proc_entries();
 	}
 
 	props.max_brightness = HCI_LCD_BRIGHTNESS_LEVELS - 1;
-- 
1.5.4.3



