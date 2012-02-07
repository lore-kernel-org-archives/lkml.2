Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565Ab2BGBF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 20:05:59 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40127 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756531Ab2BGBF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 20:05:57 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 1/8] PM / Sleep: Initialize wakeup source locks in wakeup_source_add()
Date: Tue, 7 Feb 2012 02:01:57 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>,
        markgross@thegnar.org, Matthew Garrett <mjg@redhat.com>,
        Greg KH <greg@linuxfoundation.org>,
        Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>
References: <201202070200.55505.rjw@sisk.pl>
In-Reply-To: <201202070200.55505.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201202070201.58025.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Initialize wakeup source locks in wakeup_source_add() instead of
wakeup_source_create(), because otherwise the locks of the wakeup
sources that haven't been allocated with wakeup_source_create()
aren't initialized and handled properly.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/wakeup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/base/power/wakeup.c
===================================================================
--- linux.orig/drivers/base/power/wakeup.c
+++ linux/drivers/base/power/wakeup.c
@@ -64,7 +64,6 @@ struct wakeup_source *wakeup_source_crea
 	if (!ws)
 		return NULL;
 
-	spin_lock_init(&ws->lock);
 	if (name)
 		ws->name = kstrdup(name, GFP_KERNEL);
 
@@ -105,6 +104,7 @@ void wakeup_source_add(struct wakeup_sou
 	if (WARN_ON(!ws))
 		return;
 
+	spin_lock_init(&ws->lock);
 	setup_timer(&ws->timer, pm_wakeup_timer_fn, (unsigned long)ws);
 	ws->active = false;
 

