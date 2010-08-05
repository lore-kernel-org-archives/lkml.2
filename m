Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760979Ab0HEWdo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:33:44 -0400
Received: from kroah.org ([198.145.64.141]:37769 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934536Ab0HEWYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:24:51 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Axel Lin <axel.lin@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 14/28] dmi-id: fix a memory leak in dmi_id_init error path
Date: Thu,  5 Aug 2010 15:24:04 -0700
Message-Id: <1281047058-23716-14-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213314.GB13744@kroah.com>
References: <20100805213314.GB13744@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Axel Lin <axel.lin@gmail.com>

This patch adds a missing kfree(dmi_dev) in dmi_id_init error path.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/firmware/dmi-id.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/firmware/dmi-id.c b/drivers/firmware/dmi-id.c
index a777a35..94a58a0 100644
--- a/drivers/firmware/dmi-id.c
+++ b/drivers/firmware/dmi-id.c
@@ -229,10 +229,12 @@ static int __init dmi_id_init(void)
 
 	ret = device_register(dmi_dev);
 	if (ret)
-		goto fail_class_unregister;
+		goto fail_free_dmi_dev;
 
 	return 0;
 
+fail_free_dmi_dev:
+	kfree(dmi_dev);
 fail_class_unregister:
 
 	class_unregister(&dmi_class);
-- 
1.7.2

