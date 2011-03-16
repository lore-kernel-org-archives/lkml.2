Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab1CPVMK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:12:10 -0400
Received: from kroah.org ([198.145.64.141]:42548 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754216Ab1CPVLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:11:36 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Borislav Petkov <borislav.petkov@amd.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 07/50] sysdev: Fixup warning message
Date: Wed, 16 Mar 2011 14:10:45 -0700
Message-Id: <1300309888-5028-7-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300309888-5028-1-git-send-email-gregkh@suse.de>
References: <20110316205204.GA2686@kroah.com>
 <1300309888-5028-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Use gcc's __func__ instead of the function name.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/sys.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index 1667aaf..b094e0d 100644
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -181,8 +181,8 @@ int sysdev_driver_register(struct sysdev_class *cls, struct sysdev_driver *drv)
 	int err = 0;
 
 	if (!cls) {
-		WARN(1, KERN_WARNING "sysdev: invalid class passed to "
-			"sysdev_driver_register!\n");
+		WARN(1, KERN_WARNING "sysdev: invalid class passed to %s!\n",
+			__func__);
 		return -EINVAL;
 	}
 
-- 
1.7.4.1

