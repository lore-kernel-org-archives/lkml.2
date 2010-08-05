Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760976Ab0HEWcA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:32:00 -0400
Received: from kroah.org ([198.145.64.141]:37801 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934567Ab0HEWY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:24:58 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jike Song <albcamus@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 19/28] driver core: fix memory leak on one error path in bus_register()
Date: Thu,  5 Aug 2010 15:24:09 -0700
Message-Id: <1281047058-23716-19-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213314.GB13744@kroah.com>
References: <20100805213314.GB13744@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jike Song <albcamus@gmail.com>

Reported-by: huangweibing@gmail.com
Signed-off-by: Jike Song <albcamus@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/bus.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 12eec3f..eb1b7fa 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -945,8 +945,8 @@ bus_devices_fail:
 	bus_remove_file(bus, &bus_attr_uevent);
 bus_uevent_fail:
 	kset_unregister(&bus->p->subsys);
-	kfree(bus->p);
 out:
+	kfree(bus->p);
 	bus->p = NULL;
 	return retval;
 }
-- 
1.7.2

