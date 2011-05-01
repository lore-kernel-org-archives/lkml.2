Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758495Ab1EABo6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:44:58 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52252 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028Ab1EABiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:38:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=K6K6E0xG10ONnUPNcpBd2IbNrV7Bb7v/L8Q3hV7yz925hGAuqU70x+/n7P0YlSfq/F
         uMdf5bBISx7Dg4PZZgUIZM1IhcwqA5z8wkIz7fq8CUFb3Z+n3OmESwGvPT7q2Cytqs72
         zmA8Wicwei+7jrmdOgTMwveX0mWSJ4wws7jB4=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 63/69] sysctl: single subheader path: net/{ipv4|ipv6}/neigh/DEV/
Date: Sun,  1 May 2011 03:36:33 +0200
Message-Id: <1304213799-10257-64-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 net/core/neighbour.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 799f06e..63677be 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -2818,7 +2818,13 @@ int neigh_sysctl_register(struct net_device *dev, struct neigh_parms *p,
 		{ .procname = "net",	 },
 		{ .procname = "proto",	 },
 		{ .procname = "neigh",	 },
-		{ .procname = "default", },
+		{
+			/* will be set to device name (NEIGH_CTL_PATH_DEV) */
+			.procname = "default",
+			/* skip duplicate name check; we're registering
+			 * just one subheader for this directory */
+			.has_just_one_subheader = 1,
+		},
 		{ },
 	};
 
-- 
1.7.5.134.g1c08b

