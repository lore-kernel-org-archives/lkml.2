Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030445Ab2CGV6q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:58:46 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:56860 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758309Ab2CGV6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:58:39 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Colin Cross <ccross@android.com>, Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 05/13] android: ram_console: drop verbose ram_console support
Date: Wed,  7 Mar 2012 13:58:15 -0800
Message-Id: <1331157503-3413-6-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1331157503-3413-1-git-send-email-john.stultz@linaro.org>
References: <1331157503-3413-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030721-6148-0000-0000-000004138DB6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

Equivalent functionality can be obtained with loglevel=15

CC: Greg KH <gregkh@linuxfoundation.org>
CC: Android Kernel Team <kernel-team@android.com>
Change-Id: I977d70f3b72fd48cfbb9f791de37e74ac711ce21
Signed-off-by: Colin Cross <ccross@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/Kconfig       |    5 -----
 drivers/staging/android/ram_console.c |    3 ---
 2 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/android/Kconfig b/drivers/staging/android/Kconfig
index 20034e6..3144ddb 100644
--- a/drivers/staging/android/Kconfig
+++ b/drivers/staging/android/Kconfig
@@ -30,11 +30,6 @@ config ANDROID_RAM_CONSOLE
 	depends on !S390 && !UML
 	default n
 
-config ANDROID_RAM_CONSOLE_ENABLE_VERBOSE
-	bool "Enable verbose console messages on Android RAM console"
-	default y
-	depends on ANDROID_RAM_CONSOLE
-
 menuconfig ANDROID_RAM_CONSOLE_ERROR_CORRECTION
 	bool "Android RAM Console Enable error correction"
 	default n
diff --git a/drivers/staging/android/ram_console.c b/drivers/staging/android/ram_console.c
index ed7827b..73215e2 100644
--- a/drivers/staging/android/ram_console.c
+++ b/drivers/staging/android/ram_console.c
@@ -285,9 +285,6 @@ static int __init ram_console_init(struct ram_console_buffer *buffer,
 	buffer->size = 0;
 
 	register_console(&ram_console);
-#ifdef CONFIG_ANDROID_RAM_CONSOLE_ENABLE_VERBOSE
-	console_verbose();
-#endif
 	return 0;
 }
 
-- 
1.7.3.2.146.gca209

