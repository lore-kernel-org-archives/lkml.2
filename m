Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303Ab1GFVBm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 17:01:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33636 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756296Ab1GFVBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 17:01:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 5/5 v1] PM / Domains: Do not restore all devices on power off error
Date: Wed, 6 Jul 2011 23:01:21 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Kevin Hilman <khilman@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, Paul Walmsley <paul@pwsan.com>,
        Greg KH <gregkh@suse.de>, Magnus Damm <magnus.damm@gmail.com>
References: <201107062248.35586.rjw@sisk.pl>
In-Reply-To: <201107062248.35586.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107062301.22277.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Since every device in a PM domain has its own need_restore
flag, which is set by __pm_genpd_save_device(), there's no need to
walk the domain's device list and restore all devices on an error
from one of the drivers' .runtime_suspend() callbacks.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/domain.c |    3 ---
 1 file changed, 3 deletions(-)

Index: linux-2.6/drivers/base/power/domain.c
===================================================================
--- linux-2.6.orig/drivers/base/power/domain.c
+++ linux-2.6/drivers/base/power/domain.c
@@ -299,9 +299,6 @@ static int pm_genpd_poweroff(struct gene
 	return 0;
 
  err_dev:
-	list_for_each_entry_continue(dle, &genpd->dev_list, node)
-		__pm_genpd_restore_device(dle, genpd);
-
 	genpd_set_active(genpd);
 	wake_up_all(&genpd->status_wait_queue);
 

