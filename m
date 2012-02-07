Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625Ab2BGFNb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 00:13:31 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49724 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab2BGFNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 00:13:30 -0500
Date: Tue, 7 Feb 2012 09:13:27 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: San Mehat <san@google.com>, Colin Cross <ccross@android.com>,
        Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        kernel-team@android.com, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: android/ram_console: Don't build on arches w/o
 ioremap
Message-ID: <20120207051327.GA11737@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes UML build:

    CC      drivers/staging/android/ram_console.o
  drivers/staging/android/ram_console.c: In function
  'ram_console_driver_probe':
  drivers/staging/android/ram_console.c:358:2: error: implicit declaration
  of function 'ioremap' [-Werror=implicit-function-declaration]
  cc1: some warnings being treated as errors
  make[3]: *** [drivers/staging/android/ram_console.o] Error 1

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 drivers/staging/android/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/android/Kconfig b/drivers/staging/android/Kconfig
index becf711..2054ccb 100644
--- a/drivers/staging/android/Kconfig
+++ b/drivers/staging/android/Kconfig
@@ -27,6 +27,7 @@ config ANDROID_LOGGER
 
 config ANDROID_RAM_CONSOLE
 	bool "Android RAM buffer console"
+	depends on !S390 && !UML
 	default n
 
 config ANDROID_RAM_CONSOLE_ENABLE_VERBOSE
-- 
1.7.7.6
