Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932644Ab1EHWmI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 18:42:08 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49055 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932626Ab1EHWmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 18:42:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=jyz856O6ZYL1aXZWSxEUt5QyZaQunKXFWAyZNC3SdeyUmEM9WGTFpNUoBf3RNxprsg
         QlSZOmDoTJ9lzFDCY8pkv8/kwtLJbWya2TX1bZte43JV6hxk14bCj7ra9Xbq2w4k1+2J
         kk7yzUODvhX8Mcj5cbA0bNQIlOpi7rRniYIL0=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [v2 081/115] sysctl: single subheader path: net/{ipv4|ipv6}/neigh/DEV/
Date: Mon,  9 May 2011 00:39:33 +0200
Message-Id: <1304894407-32201-82-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
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

