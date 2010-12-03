Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261Ab0LCA32 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 19:29:28 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50180 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758202Ab0LCA3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 19:29:23 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 3/3] PM: Use pm_wakeup_pending() in device_suspend()
Date: Fri, 3 Dec 2010 01:23:43 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc4+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
References: <201012030118.30603.rjw@sisk.pl>
In-Reply-To: <201012030118.30603.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012030123.43786.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Before starting to suspend a device in device_suspend() check if
there's a request to abort the power transition and return -EBUSY
in that case.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/main.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -935,6 +935,11 @@ static void async_suspend(void *data, as
 
 static int device_suspend(struct device *dev)
 {
+	if (pm_wakeup_pending()) {
+		async_error = -EBUSY;
+		return async_error;
+	}
+
 	INIT_COMPLETION(dev->power.completion);
 
 	if (pm_async_enabled && dev->power.async_suspend) {

