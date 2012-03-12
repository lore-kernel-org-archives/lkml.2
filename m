Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886Ab2CLTtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 15:49:19 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:37429 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756440Ab2CLTtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 15:49:00 -0400
X-Greylist: delayed 911 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Mar 2012 15:48:58 EDT
Message-Id: <201203121933.q2CJXjVw017999@farm-0023.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 12 Mar 2012 15:15:21 -0400
Subject: [PATCH] arch/tile: Fix up from commit 8a25a2fd126c621f44f3aeaef80d51f00fc11639
To: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 12 Mar 2012 19:33:46.0174 (UTC) FILETIME=[0A9515E0:01CD0087]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was Kay Siever's bombing to convert 'cpu' to a regular subsystem.
The change left a bogus second argument to sysfs_create_file().

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/sysfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/tile/kernel/sysfs.c b/arch/tile/kernel/sysfs.c
index f862b00..71ae728 100644
--- a/arch/tile/kernel/sysfs.c
+++ b/arch/tile/kernel/sysfs.c
@@ -163,7 +163,7 @@ static int __init create_sysfs_entries(void)
 
 #define create_hv_attr(name)						\
 	if (!err)							\
-		err = sysfs_create_file(hypervisor_kobj, &dev_attr_##name);
+		err = sysfs_create_file(hypervisor_kobj, &dev_attr_##name.attr);
 	create_hv_attr(type);
 	create_hv_attr(version);
 	create_hv_attr(config_version);
-- 
1.6.5.2

