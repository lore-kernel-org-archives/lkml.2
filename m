Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953Ab1KTAzV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 19:55:21 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47848 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497Ab1KTAyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 19:54:36 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 2/3] PM / Sleep: Correct inaccurate information in devices.txt
Date: Sun, 20 Nov 2011 01:56:01 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Randy Dunlap <rdunlap@xenotime.net>
References: <201111200153.40224.rjw@sisk.pl>
In-Reply-To: <201111200153.40224.rjw@sisk.pl>
MIME-Version: 1.0
Message-Id: <201111200156.02161.rjw@sisk.pl>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The documentation file Documentation/power/devices.txt contains some
information that isn't correct any more due to code modifications
made after that file had been created (or updated last time).  Fix
this.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 Documentation/power/devices.txt |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

Index: linux/Documentation/power/devices.txt
===================================================================
--- linux.orig/Documentation/power/devices.txt
+++ linux/Documentation/power/devices.txt
@@ -250,7 +250,7 @@ for every device before the next phase b
 support all these callbacks and not all drivers use all the callbacks.  The
 various phases always run after tasks have been frozen and before they are
 unfrozen.  Furthermore, the *_noirq phases run at a time when IRQ handlers have
-been disabled (except for those marked with the IRQ_WAKEUP flag).
+been disabled (except for those marked with the IRQF_NO_SUSPEND flag).
 
 All phases use PM domain, bus, type, or class callbacks (that is, methods
 defined in dev->pm_domain->ops, dev->bus->pm, dev->type->pm, or dev->class->pm).
@@ -295,9 +295,8 @@ When the system goes into the standby or
 
 	After the prepare callback method returns, no new children may be
 	registered below the device.  The method may also prepare the device or
-	driver in some way for the upcoming system power transition (for
-	example, by allocating additional memory required for this purpose), but
-	it should not put the device into a low-power state.
+	driver in some way for the upcoming system power transition, but it
+	should not put the device into a low-power state.
 
     2.	The suspend methods should quiesce the device to stop it from performing
 	I/O.  They also may save the device registers and put it into the

