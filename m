Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab2GJQHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 12:07:48 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:47018 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753314Ab2GJQHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 12:07:46 -0400
From: Federico Fuga <fuga@studiofuga.com>
To: linux-kernel@vger.kernel.org
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Federico Fuga <fuga@studiofuga.com>
Subject: [PATCH] rpmsg bus subsys_initcall initialization ordering
Date: Tue, 10 Jul 2012 18:07:24 +0200
Message-Id: <1341936444-3094-1-git-send-email-fuga@studiofuga.com>
X-Mailer: git-send-email 1.7.9.5
X-Identified-User: {2354:box484.bluehost.com:happycac:studiofuga.com} {sentby:smtp auth 95.241.194.105 authed with fuga+studiofuga.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

omaprpc depends on the rpmsg bus.
When those two modules are compiled statically, the omaprpc is initialized before the rpmsg bus, triggering a BUG() in driver_register.
This of course can be prevented if they are compiled as modules and loaded in the right order.
This patch solves this problem by forcing the rpmsg module to be initialized at subsystem level.

Signed-off-by: Federico Fuga <fuga@studiofuga.com>
---
 drivers/rpmsg/virtio_rpmsg_bus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
index 210c4eb..589819f 100644
--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -1078,7 +1078,7 @@ static int __init rpmsg_init(void)
 
 	return ret;
 }
-module_init(rpmsg_init);
+subsys_initcall(rpmsg_init);
 
 static void __exit rpmsg_fini(void)
 {
-- 
1.7.9.5

