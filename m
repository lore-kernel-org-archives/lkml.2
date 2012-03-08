Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab2CHJIO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 04:08:14 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:1187 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582Ab2CHJII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 04:08:08 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6642"; a="168261685"
From: Stephen Boyd <sboyd@codeaurora.org>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>
Subject: [PATCH] staging: ram_console: Fix section mismatches
Date: Thu,  8 Mar 2012 01:08:04 -0800
Message-Id: <1331197684-9163-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.9.3.327.g2980b
In-Reply-To: <1331170478-30538-1-git-send-email-john.stultz@linaro.org>
References: <1331170478-30538-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: vmlinux.o(.text+0x25d5fc): Section mismatch in reference
from the function ram_console_driver_probe() to the function
.init.text:ram_console_init()
The function ram_console_driver_probe() references
the function __init ram_console_init().
This is often because ram_console_driver_probe lacks a __init
annotation or the annotation of ram_console_init is wrong.

Mark ram_console_driver_probe() as __devinit because it's a probe
function and propagate the __devinit markings to the __init
functions the probe calls.

Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

Can we merge this patch too? Maybe we can get rid of the 
lateinit call too?

 drivers/staging/android/ram_console.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/android/ram_console.c b/drivers/staging/android/ram_console.c
index 73215e2..9525994 100644
--- a/drivers/staging/android/ram_console.c
+++ b/drivers/staging/android/ram_console.c
@@ -153,7 +153,7 @@ void ram_console_enable_console(int enabled)
 		ram_console.flags &= ~CON_ENABLED;
 }
 
-static void __init
+static void __devinit
 ram_console_save_old(struct ram_console_buffer *buffer, char *dest)
 {
 	size_t old_log_size = buffer->size;
@@ -205,7 +205,7 @@ ram_console_save_old(struct ram_console_buffer *buffer, char *dest)
 	       &buffer->data[0], buffer->start);
 }
 
-static int __init ram_console_init(struct ram_console_buffer *buffer,
+static int __devinit ram_console_init(struct ram_console_buffer *buffer,
 				   size_t buffer_size, char *old_buf)
 {
 #ifdef CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION
@@ -306,7 +306,7 @@ static ssize_t ram_console_ecc_string(char *str, size_t len)
 #endif
 }
 
-static int ram_console_driver_probe(struct platform_device *pdev)
+static int __devinit ram_console_driver_probe(struct platform_device *pdev)
 {
 	struct resource *res = pdev->resource;
 	size_t start;
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

