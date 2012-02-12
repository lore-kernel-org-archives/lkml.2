Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab2BLXfM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 18:35:12 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48874 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755897Ab2BLXfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 18:35:10 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH] PM: Add comment describing relationships between PM callbacks to pm.h
Date: Mon, 13 Feb 2012 00:39:02 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Kevin Hilman <khilman@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Magnus Damm <magnus.damm@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201202130039.02184.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The UNIVERSAL_DEV_PM_OPS() macro is slightly misleading, because it
may suggest that it's a good idea to point runtime PM callback
pointers to the same routines as system suspend/resume callbacks
.suspend() and .resume(), which is not the case.  For this reason,
add a comment to include/linux/pm.h, next to the definition of
UNIVERSAL_DEV_PM_OPS(), describing how device PM callbacks are
related to each other.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 include/linux/pm.h |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux/include/linux/pm.h
===================================================================
--- linux.orig/include/linux/pm.h
+++ linux/include/linux/pm.h
@@ -320,6 +320,15 @@ const struct dev_pm_ops name = { \
 /*
  * Use this for defining a set of PM operations to be used in all situations
  * (sustem suspend, hibernation or runtime PM).
+ * NOTE: In general, system suspend callbacks, .suspend() and .resume(), should
+ * be different from the corresponding runtime PM callbacks, .runtime_suspend(),
+ * and .runtime_resume(), because .runtime_suspend() always works on an already
+ * quiescent device, while .suspend() should assume that the device may be doing
+ * something when it is called (it should ensure that the device will be
+ * quiescent after it has returned).  Therefore it's better to point the "late"
+ * suspend and "early" resume callback pointers, .suspend_late() and
+ * .resume_early(), to the same routines as .runtime_suspend() and
+ * .runtime_resume(), respectively (and analogously for hibernation).
  */
 #define UNIVERSAL_DEV_PM_OPS(name, suspend_fn, resume_fn, idle_fn) \
 const struct dev_pm_ops name = { \
