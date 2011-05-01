Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133Ab1EABon (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:44:43 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61911 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756145Ab1EABiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:38:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=A2+kwaSTqpOfQYFmYsZcK8mRPtQWzwZ92058oE7EqFZDycecOx4Iz1qoTrIvk3Ro9v
         AZr3wrnKgFQi/FzHcn9F9dHKedvrsDEXu1VTXM69OaKsDSdtODyk0t/x+l+EtNAst2Xi
         vW87PnK9H1G4MC0qaTvHygxlzzmODjPQOJcN0=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 64/69] sysctl: single subheader path: net/ipv6/conf/DEVICE-NAME/
Date: Sun,  1 May 2011 03:36:34 +0200
Message-Id: <1304213799-10257-65-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 net/ipv6/addrconf.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 1493534..9e2feb0 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4486,7 +4486,13 @@ static int __addrconf_sysctl_register(struct net *net, char *dev_name,
 		{ .procname = "net", },
 		{ .procname = "ipv6", },
 		{ .procname = "conf", },
-		{ /* to be set */ },
+		{
+			/* to be set bellow (ADDRCONF_CTL_PATH_DEV) */
+			.procname = NULL,
+			/* skip duplicate name check; we're registering
+			 * just one subheader for this directory */
+			.has_just_one_subheader = 1,
+		},
 		{ },
 	};
 
-- 
1.7.5.134.g1c08b

