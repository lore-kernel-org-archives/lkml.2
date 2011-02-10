Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317Ab1BJXdK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:33:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34460 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752386Ab1BJXdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:33:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-pm@lists.linux-foundation.org
Subject: [Updated][PATCH 5/5] PM: Clean up PM_TRACE dependencies and drop unnecessary Kconfig option
Date: Fri, 11 Feb 2011 00:32:48 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc4+; KDE/4.4.4; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Len Brown <len.brown@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-embedded@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
References: <1297081335-13631-1-git-send-email-broonie@opensource.wolfsonmicro.com> <201102082218.28015.rjw@sisk.pl> <201102082223.37975.rjw@sisk.pl>
In-Reply-To: <201102082223.37975.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102110032.48810.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 08, 2011, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> CONFIG_PM_SLEEP_ADVANCED_DEBUG should depend on CONFIG_PM_SLEEP
> and CONFIG_CAN_PM_TRACE need not depend on EXPERIMENTAL.  Modify
> kernel/power/Kconfig along those lines.

It turns out that CONFIG_PM_SLEEP_ADVANCED_DEBUG is not used any more, so we
can simply get rid of it.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM: Clean up PM_TRACE dependencies and drop unnecessary Kconfig option

CONFIG_PM_SLEEP_ADVANCED_DEBUG is not used any more, so drop it
and CONFIG_CAN_PM_TRACE need not depend on EXPERIMENTAL, so remove
that dependency.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/Kconfig |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

Index: linux-2.6/kernel/power/Kconfig
===================================================================
--- linux-2.6.orig/kernel/power/Kconfig
+++ linux-2.6/kernel/power/Kconfig
@@ -140,11 +140,6 @@ config PM_ADVANCED_DEBUG
 	fields of device objects from user space.  If you are not a kernel
 	developer interested in debugging/testing Power Management, say "no".
 
-config PM_SLEEP_ADVANCED_DEBUG
-	bool
-	depends on PM_ADVANCED_DEBUG
-	default n
-
 config PM_TEST_SUSPEND
 	bool "Test suspend/resume and wakealarm during bootup"
 	depends on SUSPEND && PM_DEBUG && RTC_CLASS=y
@@ -158,7 +153,7 @@ config PM_TEST_SUSPEND
 
 config CAN_PM_TRACE
 	def_bool y
-	depends on PM_DEBUG && PM_SLEEP && EXPERIMENTAL
+	depends on PM_DEBUG && PM_SLEEP
 
 config PM_TRACE
 	bool
