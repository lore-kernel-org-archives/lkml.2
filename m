Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab2JBCFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 22:05:19 -0400
Received: from noserose.net ([66.220.18.76]:36622 "HELO noserose.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752399Ab2JBCFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 22:05:18 -0400
Date: Mon, 1 Oct 2012 19:05:15 -0700
Message-Id: <4b1456739285d5a7a153ba74a51f3e3bfd5c4a53.1349104674.git.ecashin@coraid.com>
In-Reply-To: <3c9c2338b9c963e1d5f19cc9ed51b01cf829eeee.1349104674.git.ecashin@coraid.com>
References: <3c9c2338b9c963e1d5f19cc9ed51b01cf829eeee.1349104674.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Subject: [PATCH 4/7] aoe: make dynamic block minor numbers the default
To: akpm@linux-foundation.org
Cc: ecashin@coraid.com, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because udev use is so widespread, making the old static mapping
the default is too conservative, given the severe limitations it
places on usable AoE addresses.  Storage virtualization and
larger shelves have made the old limitations too confining.

These changes make the dynamic block device minor numbers the
default, removing the limitations on usable AoE addresses.

The static arrangement is still available with aoe_dyndevs=0, and
the aoe-stat tool from the userland aoetools package, the user
space counterpart to the aoe driver, recognizes the case where
there is a mismatch between the minor number in sysfs and the
minor number in a special device file.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoedev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/aoe/aoedev.c b/drivers/block/aoe/aoedev.c
index 3d494fd..90e5b53 100644
--- a/drivers/block/aoe/aoedev.c
+++ b/drivers/block/aoe/aoedev.c
@@ -19,7 +19,7 @@ static void aoedev_freedev(struct aoedev *);
 static void freetgt(struct aoedev *d, struct aoetgt *t);
 static void skbpoolfree(struct aoedev *d);
 
-static int aoe_dyndevs;
+static int aoe_dyndevs = 1;
 module_param(aoe_dyndevs, int, 0644);
 MODULE_PARM_DESC(aoe_dyndevs, "Use dynamic minor numbers for devices.");
 
-- 
1.7.1

