Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934400Ab0EURBw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 13:01:52 -0400
Received: from kroah.org ([198.145.64.141]:39082 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934216Ab0EUQyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:54:15 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 06/38] Driver core: don't initialize wakeup flags
Date: Fri, 21 May 2010 09:53:36 -0700
Message-Id: <1274460848-11377-6-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165106.GA11216@kroah.com>
References: <20100521165106.GA11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

This patch (as1351) removes an unnecessary and unwanted assignment
from device_initialize().  The wakeup flags are set to 0 along with
everything else when the device structure is allocated, so we don't
need to do it again.  Furthermore, the subsystem might already have
set these flags to their correct values; we don't want to override it.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index b56a0ba..e11c8c3 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -562,7 +562,6 @@ void device_initialize(struct device *dev)
 	init_MUTEX(&dev->sem);
 	spin_lock_init(&dev->devres_lock);
 	INIT_LIST_HEAD(&dev->devres_head);
-	device_init_wakeup(dev, 0);
 	device_pm_init(dev);
 	set_dev_node(dev, -1);
 }
-- 
1.7.0.3

