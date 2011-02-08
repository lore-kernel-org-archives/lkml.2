Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab1BHVYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 16:24:37 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54977 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125Ab1BHVYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 16:24:34 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 5/5] PM: Clean up Kconfig dependencies
Date: Tue, 8 Feb 2011 22:23:37 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc4+; KDE/4.4.4; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Len Brown <len.brown@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-embedded@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
References: <1297081335-13631-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20110208122159.GA8284@elte.hu> <201102082218.28015.rjw@sisk.pl>
In-Reply-To: <201102082218.28015.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102082223.37975.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

CONFIG_PM_SLEEP_ADVANCED_DEBUG should depend on CONFIG_PM_SLEEP
and CONFIG_CAN_PM_TRACE need not depend on EXPERIMENTAL.  Modify
kernel/power/Kconfig along those lines.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/power/Kconfig
===================================================================
--- linux-2.6.orig/kernel/power/Kconfig
+++ linux-2.6/kernel/power/Kconfig
@@ -142,7 +142,7 @@ config PM_ADVANCED_DEBUG
 
 config PM_SLEEP_ADVANCED_DEBUG
 	bool
-	depends on PM_ADVANCED_DEBUG
+	depends on PM_ADVANCED_DEBUG && PM_SLEEP
 	default n
 
 config PM_TEST_SUSPEND
@@ -158,7 +158,7 @@ config PM_TEST_SUSPEND
 
 config CAN_PM_TRACE
 	def_bool y
-	depends on PM_DEBUG && PM_SLEEP && EXPERIMENTAL
+	depends on PM_DEBUG && PM_SLEEP
 
 config PM_TRACE
 	bool

