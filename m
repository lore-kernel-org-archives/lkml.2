Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758366Ab1EABpA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:45:00 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62471 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932233Ab1EABiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:38:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ufylDLS+mpTJ5dRM2XTuF7l6PR4C2PQg0pERGpl2TOrCt2MJa3Sytfy/aLonoeKRDL
         jZOPtkjRAVMKGdysSRa623yPDR6lTbHEQbN+axDSJoDuC1TlWeNXSFt3yzRaDd7v5frE
         QdMhVUEu6HNB1js2OBt1kbqwi0UXkfGtozbSQ=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 62/69] sysctl: single subheader path: net/ipv4/conf/DEVICE-NAME/
Date: Sun,  1 May 2011 03:36:32 +0200
Message-Id: <1304213799-10257-63-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 net/ipv4/devinet.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 5345b0b..a9e2094 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1631,7 +1631,13 @@ static int __devinet_sysctl_register(struct net *net, char *dev_name,
 		{ .procname = "net",  },
 		{ .procname = "ipv4", },
 		{ .procname = "conf", },
-		{ /* to be set */ },
+		{
+			/* to be set bellow (DEVINET_CTL_PATH_DEV) */
+			.procname = NULL,
+			/* skip duplicate name check; we're registering
+			 * just one subheader for this directory */
+			.has_just_one_subheader = 1,
+		},
 		{ },
 	};
 
-- 
1.7.5.134.g1c08b

