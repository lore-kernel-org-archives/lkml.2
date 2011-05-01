Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352Ab1EABo3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:44:29 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49864 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758357Ab1EABiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:38:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JEryfzaFg5shWHDII1Z7q9vBfRiKiXdGd5huQ5Hq289Hnvgy2FvFs7CZ8cbhw1vMZF
         KQaK2Xxyf7BiHtCQP74F1EYSNU0qssuGpFqqrW82myUMCYvNY+KAst1UMagnKF6QRe00
         4Jy19/SAXPIMOXluQ19mHv8Yk3+75Ke8Dsjp0=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 65/69] sysctl: single subheader path: dev/parport/PORT/devices/DEVICE/
Date: Sun,  1 May 2011 03:36:35 +0200
Message-Id: <1304213799-10257-66-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch was not tested!

Parport registers tables under these paths:
	dev/parport/default/
	dev/parport/PORT/
	dev/parport/PORT/devices/
	dev/parport/PORT/devices/DEVICE/

Nothing else is registered below dev/parport/PORT/devices/DEVICE/ and
I assume device names are unique (if they are not this patch is
invalid), so we can skip name checks for the 'DEVICE' directory.

This will have a positive performance impact when there are many
devices registered on the same port.

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 drivers/parport/procfs.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/parport/procfs.c b/drivers/parport/procfs.c
index 3bb5bed..9c48946 100644
--- a/drivers/parport/procfs.c
+++ b/drivers/parport/procfs.c
@@ -442,7 +442,12 @@ int parport_device_proc_register(struct pardevice *device)
 		{ .procname = "parport" },
 		{ .procname = port->name },
 		{ .procname = "devices" },
-		{ .procname = device->name },
+		{
+			.procname = device->name,
+			/* skip duplicate name check; we're registering
+			 * just one subheader for this directory */
+			.has_just_one_subheader = 1,
+		},
 		{  },
 	};
 
-- 
1.7.5.134.g1c08b

