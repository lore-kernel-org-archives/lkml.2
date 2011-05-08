Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664Ab1EHWmM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 18:42:12 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51704 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932620Ab1EHWmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 18:42:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hYiqmeLgLBPCx9+Ann05F1xVrkCuIEMlRW2zsawlUWHY1UdhIrC8KhtGtrtWauK8gR
         Uvr0QvZJZMC/JQTd4YIpx9/L3uZtjFgsVwnBS3bkCToYvuO6FGf2TSjzkdugfGyQmcoY
         Enyp+WLyD4mEfmzDtvU7m1VC+XIb/DSQW0Jhw=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [v2 080/115] sysctl: single subheader path: net/ipv4/conf/DEVICE-NAME/
Date: Mon,  9 May 2011 00:39:32 +0200
Message-Id: <1304894407-32201-81-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 net/ipv4/devinet.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index cd9ca08..e672107 100644
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

