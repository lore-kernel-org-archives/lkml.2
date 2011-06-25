Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380Ab1FYVbo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 17:31:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58109 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191Ab1FYVbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 17:31:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 2/10 v6] PM: subsys_data in struct dev_pm_info need not depend on RM_RUNTIME
Date: Sat, 25 Jun 2011 23:25:33 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, Magnus Damm <magnus.damm@gmail.com>,
        Paul Walmsley <paul@pwsan.com>, Kevin Hilman <khilman@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
References: <201106112223.04972.rjw@sisk.pl> <201106252324.13454.rjw@sisk.pl>
In-Reply-To: <201106252324.13454.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106252325.34214.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The subsys_data field of struct dev_pm_info, introduced by commit
1d2b71f61b6a10216274e27b717becf9ae101fc7 (PM / Runtime: Add subsystem
data field to struct dev_pm_info), is going to be used even if
CONFIG_PM_RUNTIME is not set, so move it from under the #ifdef.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 include/linux/pm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/include/linux/pm.h
===================================================================
--- linux-2.6.orig/include/linux/pm.h
+++ linux-2.6/include/linux/pm.h
@@ -461,8 +461,8 @@ struct dev_pm_info {
 	unsigned long		active_jiffies;
 	unsigned long		suspended_jiffies;
 	unsigned long		accounting_timestamp;
-	void			*subsys_data;  /* Owned by the subsystem. */
 #endif
+	void			*subsys_data;  /* Owned by the subsystem. */
 };
 
 extern void update_pm_runtime_accounting(struct device *dev);

