Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab1BAQTK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 11:19:10 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44315 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab1BAQTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 11:19:09 -0500
From: Borislav Petkov <bp@amd64.org>
To: <greg@kroah.com>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 2/2] sysdev: Fixup warning message
Date: Tue,  1 Feb 2011 17:19:57 +0100
Message-Id: <1296577197-9766-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Use gcc's __func__ instead of the function name.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---

Patch against next-20110201.

 drivers/base/sys.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index a1eeff0..f6fb547 100644
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -211,8 +211,8 @@ int sysdev_driver_register(struct sysdev_class *cls, struct sysdev_driver *drv)
 	int err = 0;
 
 	if (!cls) {
-		WARN(1, KERN_WARNING "sysdev: invalid class passed to "
-			"sysdev_driver_register!\n");
+		WARN(1, KERN_WARNING "sysdev: invalid class passed to %s!\n",
+			__func__);
 		return -EINVAL;
 	}
 
-- 
1.7.4.rc2

