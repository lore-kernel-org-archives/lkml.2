Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab0FDMRb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 08:17:31 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:56026 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab0FDMRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 08:17:30 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Len Brown <len.brown@intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Magnus Damm <damm@igel.co.jp>, Alan Stern <stern@rowland.harvard.edu>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       linux-pm@lists.linux-foundation.org
Subject: [PATCH] drivers/base/power: be more verbose in device_pm_add()
Date: Fri,  4 Jun 2010 14:17:14 +0200
Message-Id: <1275653834-9132-1-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a parentless device was added during a PM transaction, developers
might want to know which device caused the troube. Hence, output the
kobject's name in this case.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Len Brown <len.brown@intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Magnus Damm <damm@igel.co.jp>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-pm@lists.linux-foundation.org
---
 drivers/base/power/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 941fcb8..9e9fe6a 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -98,7 +98,7 @@ void device_pm_add(struct device *dev)
 		 * transition is in progress in order to avoid leaving them
 		 * unhandled down the road
 		 */
-		dev_WARN(dev, "Parentless device registered during a PM transaction\n");
+		dev_WARN(dev, "Parentless device registered during a PM transaction: %s\n", kobject_name(&dev->kobj));
 	}
 
 	list_add_tail(&dev->power.entry, &dpm_list);
-- 
1.7.1

