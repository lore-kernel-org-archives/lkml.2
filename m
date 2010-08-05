Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934166Ab0HEWZR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:25:17 -0400
Received: from kroah.org ([198.145.64.141]:37690 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760857Ab0HEWY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:24:26 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jean Delvare <khali@linux-fr.org>, Andrew Morton <akpm@osdl.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 06/28] Driver core: Drop __must_check from bus_for_each_drv()
Date: Thu,  5 Aug 2010 15:23:56 -0700
Message-Id: <1281047058-23716-6-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213314.GB13744@kroah.com>
References: <20100805213314.GB13744@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Delvare <khali@linux-fr.org>

There is little rationale for marking bus_for_each_drv() __must_check.
It is more of an iteration helper than a real function. You don't know
in advance which callback it will be used on, so you have no clue how
important it can be to check the returned value. In practice, this
helper function can be used for best-effort tasks.

As a matter of fact, bus_for_each_dev() is not marked __must_check.
So remove it from bus_for_each_drv() as well. This is the same that
was done back in October 2006 by Russell King for
device_for_each_child(), for exactly the same reasons.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Andrew Morton <akpm@osdl.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/device.h |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index 6a8276f..ddffdf7 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -84,9 +84,8 @@ struct device *bus_find_device_by_name(struct bus_type *bus,
 				       struct device *start,
 				       const char *name);
 
-int __must_check bus_for_each_drv(struct bus_type *bus,
-				  struct device_driver *start, void *data,
-				  int (*fn)(struct device_driver *, void *));
+int bus_for_each_drv(struct bus_type *bus, struct device_driver *start,
+		     void *data, int (*fn)(struct device_driver *, void *));
 
 void bus_sort_breadthfirst(struct bus_type *bus,
 			   int (*compare)(const struct device *a,
-- 
1.7.2

