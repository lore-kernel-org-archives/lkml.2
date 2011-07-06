Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118Ab1GFVCd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 17:02:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33632 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756284Ab1GFVBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 17:01:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 1/5 v1] PM / Domains: Set device state to "active" during system resume
Date: Wed, 6 Jul 2011 22:50:53 +0200
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
Message-Id: <201107062250.54261.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The runtime PM status of devices in a power domain that is not
powered off in pm_genpd_complete() should be set to "active", because
those devices are operational at this point.  Some of them may not be
in use, though, so make pm_genpd_complete() call pm_runtime_idle()
in addition to pm_runtime_set_active() for each of them.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/domain.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6/drivers/base/power/domain.c
===================================================================
--- linux-2.6.orig/drivers/base/power/domain.c
+++ linux-2.6/drivers/base/power/domain.c
@@ -786,7 +786,9 @@ static void pm_genpd_complete(struct dev
 
 	if (run_complete) {
 		pm_generic_complete(dev);
+		pm_runtime_set_active(dev);
 		pm_runtime_enable(dev);
+		pm_runtime_idle(dev);
 	}
 }
 

