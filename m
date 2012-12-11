Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443Ab2LKD3O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 22:29:14 -0500
Received: from smtp.wow.synacor.com ([64.8.70.55]:55246 "EHLO
	smtp.mail.wowway.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab2LKD3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 22:29:12 -0500
X-Spam-Rating: None
X_CMAE_Category: 0,0 Undefined,Undefined
X-CNFS-Analysis: v=1.1 cv=CIrd2VtW4t2jO5UNyUYpi19KxaV+yoPbBAtYeYHFuTA= c=1 sm=0 a=c8qTiYX8uCAA:10 a=nDghuxUhq_wA:10 a=kj9zAlcOel0A:10 a=pGLkceISAAAA:8 a=f7kJgRzcEiAnLtOiHm0A:9 a=CjuIK1q_8ugA:10 a=MSl-tDqOz04A:10 a=zsaeSSr3pazHFAQJU9uUyg==:117
X-CM-Score: 0
Authentication-Results: smtp01.wow.synacor.com smtp.mail=set@squish.homelinux.org; spf=neutral
Date: Mon, 10 Dec 2012 22:29:10 -0500
From: Paul Thompson <set.mailinglist@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix Irq Subsystem menu
Message-ID: <20121211032910.GA8203@squish.home.loc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi;

	In menuconfig, General setup -> Irq subsystem contains two
possible menu-items. Sometimes, neither menu-item exists. This
patch prevents the Irq susystem menu from appearing at all unless it
will contain at least one menu-item, preventing a confusing, empty menu.

--- linux-3.7-rc8/kernel/irq/Kconfig.orig	2012-12-05 20:59:00.963707538 -0500
+++ linux-3.7-rc8/kernel/irq/Kconfig	2012-12-05 21:00:18.454788693 -0500
@@ -3,7 +3,6 @@ config HAVE_GENERIC_HARDIRQS
 	bool
 
 if HAVE_GENERIC_HARDIRQS
-menu "IRQ subsystem"
 #
 # Interrupt subsystem related configuration options
 #
@@ -56,6 +55,13 @@ config GENERIC_IRQ_CHIP
 config IRQ_DOMAIN
 	bool
 
+# Support forced irq threading
+config IRQ_FORCED_THREADING
+       bool
+
+menu "IRQ subsystem"
+	depends on ( IRQ_DOMAIN && DEBUG_FS ) || MAY_HAVE_SPARSE_IRQ
+
 config IRQ_DOMAIN_DEBUG
 	bool "Expose hardware/virtual IRQ mapping via debugfs"
 	depends on IRQ_DOMAIN && DEBUG_FS
@@ -66,10 +72,6 @@ config IRQ_DOMAIN_DEBUG
 
 	  If you don't know what this means you don't need it.
 
-# Support forced irq threading
-config IRQ_FORCED_THREADING
-       bool
-
 config SPARSE_IRQ
 	bool "Support sparse irq numbering" if MAY_HAVE_SPARSE_IRQ
 	---help---

Signed-off-by: Paul Thompson <set.mailinglist@gmail.com>

