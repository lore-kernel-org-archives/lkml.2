Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747Ab1EABoE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:44:04 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49511 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758456Ab1EABiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:38:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=FzDvE06dYosLcVO9nNXwWv8VPfh4YWEbwzzkrcOKSWc3JlKQzZgsXzk+ArW6qaEKW9
         2G22iikRz1LYNeYx9EbMJGzTbX0jRQFgD65nZkk7JqoX7MGnA51NCd4cQdKT44xgaGTB
         K41Jkv3nFu0i7PSAElHjg7swFz0baPRZTMTx8=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 66/69] sysctl: single subheader path: net/ax25/DEVICE
Date: Sun,  1 May 2011 03:36:36 +0200
Message-Id: <1304213799-10257-67-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 net/ax25/sysctl_net_ax25.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/net/ax25/sysctl_net_ax25.c b/net/ax25/sysctl_net_ax25.c
index b1181bc..9bd49c0 100644
--- a/net/ax25/sysctl_net_ax25.c
+++ b/net/ax25/sysctl_net_ax25.c
@@ -160,7 +160,13 @@ void ax25_register_sysctl(struct ax25_dev *ax25_dev)
 	struct ctl_path ax25_path[] = {
 		{ .procname = "net" },
 		{ .procname = "ax25" },
-		{ .procname = ax25_dev->dev->name },
+		{
+			.procname = ax25_dev->dev->name,
+			/* skip duplicate name check; we're registering
+			 * just one subheader for this directory */
+			.has_just_one_subheader = 1,
+
+		},
 		{ }
 	};
 
-- 
1.7.5.134.g1c08b

