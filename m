Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781Ab1EHWq5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 18:46:57 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40833 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932540Ab1EHWmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 18:42:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Ax/BZKNok0+UkMj/vEy+dXJ69wiyu/477oDniKF7ApsPvB5lKri/4J9Mj3CU1/WCwy
         ia2JKE+a03PsxT2tYtyVHrEBh4Q90F+QLSBy/ieG7lfJl/W2ALRsRUrTM77dEmkCE61B
         HCJY8RZytqf942hOLceV10zEPjQ3uOzQryi70=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [v2 082/115] sysctl: single subheader path: net/ipv6/conf/DEVICE-NAME/
Date: Mon,  9 May 2011 00:39:34 +0200
Message-Id: <1304894407-32201-83-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304894407-32201-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 net/ipv6/addrconf.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index a7bda07..3a9f958 100644
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

