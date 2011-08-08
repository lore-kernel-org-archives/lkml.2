Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056Ab1HHWHr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 18:07:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:4785 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392Ab1HHWHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 18:07:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,339,1309762800"; 
   d="scan'208";a="36544673"
Subject: [Patch] Correct assignment of uid to gid in credentials
From: Tim Chen <tim.c.chen@linux.intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: ak@linux.intel.com, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Aug 2011 15:08:36 -0700
Message-ID: <1312841316.2576.49.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch corrects an erroneous assignment of uid to gid in credentials
update.

Tim

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
diff --git a/net/core/scm.c b/net/core/scm.c
index 4c1ef02..811b53f 100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -192,7 +192,7 @@ int __scm_send(struct socket *sock, struct msghdr
*msg, struct scm_cookie *p)
 					goto error;
 
 				cred->uid = cred->euid = p->creds.uid;
-				cred->gid = cred->egid = p->creds.uid;
+				cred->gid = cred->egid = p->creds.gid;
 				put_cred(p->cred);
 				p->cred = cred;
 			}


