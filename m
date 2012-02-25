Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642Ab2BYD1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 22:27:09 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:51864 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888Ab2BYD1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 22:27:07 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of andrey.warkentin@gmail.com designates 10.229.135.131 as permitted sender) smtp.mail=andrey.warkentin@gmail.com; dkim=pass header.i=andrey.warkentin@gmail.com
From: Andrei Warkentin <andrey.warkentin@gmail.com>
To: dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, andreiw@vmware.com,
        Andrei Warkentin <andrey.warkentin@gmail.com>
Subject: [PATCH] DM: Minor fix to dm-snap metadata backend registration.
Date: Fri, 24 Feb 2012 21:26:52 -0500
Message-Id: <1330136812-4377-1-git-send-email-andrey.warkentin@gmail.com>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup in dm_exception_store_init was messed up.

Signed-off-by: Andrei Warkentin <andrey.warkentin@gmail.com>
---
 drivers/md/dm-exception-store.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-exception-store.c b/drivers/md/dm-exception-store.c
index 042e719..aa70f7d 100644
--- a/drivers/md/dm-exception-store.c
+++ b/drivers/md/dm-exception-store.c
@@ -283,7 +283,7 @@ int dm_exception_store_init(void)
 	return 0;
 
 persistent_fail:
-	dm_persistent_snapshot_exit();
+	dm_transient_snapshot_exit();
 transient_fail:
 	return r;
 }
-- 
1.7.8.3

