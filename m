Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067Ab1FLKRp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 06:17:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49227 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895Ab1FLKRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 06:17:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH] PM: Update documentation regarding sysdevs
Date: Sun, 12 Jun 2011 12:18:14 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106121218.14848.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The part of Documentation/power/devices.txt regarding sysdevs is not
valid any more after commit 2e711c04dbbf7a7732a3f7073b1fc285d12b369d
(PM: Remove sysdev suspend, resume and shutdown operations), so
remove it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 Documentation/power/devices.txt |   26 --------------------------
 1 file changed, 26 deletions(-)

Index: linux-2.6/Documentation/power/devices.txt
===================================================================
--- linux-2.6.orig/Documentation/power/devices.txt
+++ linux-2.6/Documentation/power/devices.txt
@@ -549,32 +549,6 @@ callbacks.  The other platforms need not
 in any way.
 
 
-System Devices
---------------
-System devices (sysdevs) follow a slightly different API, which can be found in
-
-	include/linux/sysdev.h
-	drivers/base/sys.c
-
-System devices will be suspended with interrupts disabled, and after all other
-devices have been suspended.  On resume, they will be resumed before any other
-devices, and also with interrupts disabled.  These things occur in special
-"sysdev_driver" phases, which affect only system devices.
-
-Thus, after the suspend_noirq (or freeze_noirq or poweroff_noirq) phase, when
-the non-boot CPUs are all offline and IRQs are disabled on the remaining online
-CPU, then a sysdev_driver.suspend phase is carried out, and the system enters a
-sleep state (or a system image is created).  During resume (or after the image
-has been created or loaded) a sysdev_driver.resume phase is carried out, IRQs
-are enabled on the only online CPU, the non-boot CPUs are enabled, and the
-resume_noirq (or thaw_noirq or restore_noirq) phase begins.
-
-Code to actually enter and exit the system-wide low power state sometimes
-involves hardware details that are only known to the boot firmware, and
-may leave a CPU running software (from SRAM or flash memory) that monitors
-the system and manages its wakeup sequence.
-
-
 Device Low Power (suspend) States
 ---------------------------------
 Device low-power states aren't standard.  One device might only handle
