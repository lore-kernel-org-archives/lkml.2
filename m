Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab1EABoB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:44:01 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52916 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758479Ab1EABiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:38:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=pYkiokboIyEEELLJRLQcUnvVsrg/kvcpiOrqlI9XpC4SSQoCdTQM2NgGpEjZm/ZjrV
         lDoJ/H5jtM+62EySsdi3RpI2p+l63OQ7VqpM2pxvOxG2WlrPp1Lf7vviz4upsO2KV//V
         3WGGMSKK9ugxnR9mYcPZzfJL81gVwDIg/0IhE=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 68/69] sysctl: single subheader path: net/decnet/conf/DEVNAME
Date: Sun,  1 May 2011 03:36:38 +0200
Message-Id: <1304213799-10257-69-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch was not tested!

I assume the DN_CTL_PATH_DEV .procname names are unique. If they are
not this patch is invalid.

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 net/decnet/dn_dev.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/net/decnet/dn_dev.c b/net/decnet/dn_dev.c
index 0dcaa90..d83d561 100644
--- a/net/decnet/dn_dev.c
+++ b/net/decnet/dn_dev.c
@@ -216,7 +216,13 @@ static void dn_dev_sysctl_register(struct net_device *dev, struct dn_dev_parms *
 		{ .procname = "net",  },
 		{ .procname = "decnet",  },
 		{ .procname = "conf",  },
-		{ /* to be set */ },
+		{
+			/* to be set bellow (DN_CTL_PATH_DEV) */
+			.procname = NULL,
+			/* skip duplicate name check; we're registering
+			 * just one subheader for this directory */
+			.has_just_one_subheader = 1,
+		},
 		{ },
 	};
 
-- 
1.7.5.134.g1c08b

