Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996Ab2LUXBG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 18:01:06 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:34999 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab2LUXBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 18:01:05 -0500
From: Cruz Julian Bishop <cruzjbishop@gmail.com>
To: greg@kroah.com
Cc: swetland@google.com, linux-kernel@vger.kernel.org,
        Cruz Julian Bishop <cruzjbishop@gmail.com>
Subject: [PATCH 3/3] staging: android: Add some Kconfig help entries
Date: Sat, 22 Dec 2012 09:00:46 +1000
Message-Id: <1356130846-6973-4-git-send-email-cruzjbishop@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1356130846-6973-1-git-send-email-cruzjbishop@gmail.com>
References: <1356130846-6973-1-git-send-email-cruzjbishop@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds Kconfig entries for the following:

	1: ANDROID_BINDER_IPC
	2: ASHMEM (additional text)
	3: ANDROID_LOGGER

It also changes "Register" to "Registers" in
ANDROID_LOW_MEMORY_KILLER

Finally, all "help" instances are changed to "---help---",
as recommended by kconfig-language.txt in order to visually
aid developers.

Signed-off-by: Cruz Julian Bishop <cruzjbishop@gmail.com>
---
 drivers/staging/android/Kconfig |   29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/android/Kconfig b/drivers/staging/android/Kconfig
index 0ce50d1..465a28c 100644
--- a/drivers/staging/android/Kconfig
+++ b/drivers/staging/android/Kconfig
@@ -11,19 +11,42 @@ if ANDROID
 config ANDROID_BINDER_IPC
 	bool "Android Binder IPC Driver"
 	default n
+	---help---
+	  Binder is used in Android for both communication between processes,
+	  and remote method invocation.
+
+	  This means one Android process can call a method/routine in another
+	  Android process, using Binder to identify, invoke and pass arguments
+	  between said processes.
 
 config ASHMEM
 	bool "Enable the Anonymous Shared Memory Subsystem"
 	default n
 	depends on SHMEM || TINY_SHMEM
-	help
+	---help---
 	  The ashmem subsystem is a new shared memory allocator, similar to
 	  POSIX SHM but with different behavior and sporting a simpler
 	  file-based API.
 
+	  It is, in theory, a good memory allocator for low-memory devices,
+	  because it can discard shared memory units when under memory pressure.
+
 config ANDROID_LOGGER
 	tristate "Android log driver"
 	default n
+	---help---
+	  This adds support for system-wide logging using four log buffers.
+
+	  These are:
+
+	      1: main
+	      2: events
+	      3: radio
+	      4: system
+
+	  Log reading and writing is performed via normal Linux reads and
+	  optimized writes. This optimization avoids logging having too
+	  much overhead in the system.
 
 config ANDROID_TIMED_OUTPUT
 	bool "Timed output class driver"
@@ -38,13 +61,13 @@ config ANDROID_LOW_MEMORY_KILLER
 	bool "Android Low Memory Killer"
 	default N
 	---help---
-	  Register processes to be killed when memory is low
+	  Registers processes to be killed when memory is low
 
 config ANDROID_INTF_ALARM_DEV
 	bool "Android alarm driver"
 	depends on RTC_CLASS
 	default n
-	help
+	---help---
 	  Provides non-wakeup and rtc backed wakeup alarms based on rtc or
 	  elapsed realtime, and a non-wakeup alarm on the monotonic clock.
 	  Also exports the alarm interface to user-space.
-- 
1.7.10.4

