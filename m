Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab1K0MEx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 07:04:53 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58573 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753975Ab1K0MEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 07:04:49 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 3/5] PM / Runtime: Make documentation follow the new behavior of irq_safe
Date: Sun, 27 Nov 2011 13:05:35 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Randy Dunlap <rdunlap@xenotime.net>,
        Alan Stern <stern@rowland.harvard.edu>
References: <201111271301.47244.rjw@sisk.pl>
In-Reply-To: <201111271301.47244.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111271305.35811.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The runtime PM core code behavior related to the power.irq_safe
device flag has changed recently and the documentation should be
modified to reflect it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 Documentation/power/runtime_pm.txt |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

Index: linux/Documentation/power/runtime_pm.txt
===================================================================
--- linux.orig/Documentation/power/runtime_pm.txt
+++ linux/Documentation/power/runtime_pm.txt
@@ -65,11 +65,12 @@ are referred to as subsystem-level callb
 
 By default, the callbacks are always invoked in process context with interrupts
 enabled.  However, subsystems can use the pm_runtime_irq_safe() helper function
-to tell the PM core that a device's ->runtime_suspend() and ->runtime_resume()
-callbacks should be invoked in atomic context with interrupts disabled.
-This implies that these callback routines must not block or sleep, but it also
-means that the synchronous helper functions listed at the end of Section 4 can
-be used within an interrupt handler or in an atomic context.
+to tell the PM core that their ->runtime_suspend(), ->runtime_resume() and
+->runtime_idle() callbacks may be invoked in atomic context with interrupts
+disabled for a given device.  This implies that the callback routines in
+question must not block or sleep, but it also means that the synchronous helper
+functions listed at the end of Section 4 may be used for that device within an
+interrupt handler or generally in an atomic context.
 
 The subsystem-level suspend callback is _entirely_ _responsible_ for handling
 the suspend of the device as appropriate, which may, but need not include

