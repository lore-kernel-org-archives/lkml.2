Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab0LMAYm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:24:42 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48257 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754408Ab0LMAYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 19:24:23 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
Subject: [PATCH] PM: Avoid compiler warning in pm_noirq_op()
Date: Mon, 13 Dec 2010 01:23:29 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc5+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012130123.29305.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The compiler complains that calltime may be uninitialized in
pm_noirq_op(), so add extra initialization for that variable to
avoid the warning.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -304,7 +304,7 @@ static int pm_noirq_op(struct device *de
 			pm_message_t state)
 {
 	int error = 0;
-	ktime_t calltime, delta, rettime;
+	ktime_t calltime = ktime_set(0, 0), delta, rettime;
 
 	if (initcall_debug) {
 		pr_info("calling  %s+ @ %i, parent: %s\n",
