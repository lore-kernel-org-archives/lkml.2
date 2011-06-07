Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab1FGKkK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 06:40:10 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46175 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab1FGKkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 06:40:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=akshayjoshi.com; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=IpyZBoOLD9qR+NdcUcSvueo+rYZEBa8S1NR1dYPLpYlYLX0nC+yg7uEufC1Ic6gUDg
         t33EOaeScKS8ZUyryGtCk8XSQ7BGc6TiVcHFijdxF7IqSjHV1ucmMNitt5RD9Qxkj81s
         pW7Y9FdVmuP1lKGPy4TQPtxJAdh03iFNGzejA=
From: Akshay Joshi <me@akshayjoshi.com>
Cc: Akshay Joshi <me@akshayjoshi.com>, "Serge E. Hallyn" <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "David S. Miller" <davem@davemloft.net>,
        Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] Kernel: space and brace fixes for user_namespace.c
Date: Tue,  7 Jun 2011 06:39:35 -0400
Message-Id: <1307443181-22278-2-git-send-email-me@akshayjoshi.com>
X-Mailer: git-send-email 1.7.4.4
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the space prohibitions and unnecessary braces for single statement
blocks as reported by the checkpatch.pl tool.

Signed-off-by: Akshay Joshi <me@akshayjoshi.com>
---
 kernel/user_namespace.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 9da289c..4407b8b 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -97,12 +97,10 @@ uid_t user_ns_map_uid(struct user_namespace *to, const struct cred *cred, uid_t
 	/* Is cred->user the creator of the target user_ns
 	 * or the creator of one of it's parents?
 	 */
-	for ( tmp = to; tmp != &init_user_ns;
-	      tmp = tmp->creator->user_ns ) {
-		if (cred->user == tmp->creator) {
+	for (tmp = to; tmp != &init_user_ns;
+	      tmp = tmp->creator->user_ns)
+		if (cred->user == tmp->creator)
 			return (uid_t)0;
-		}
-	}
 
 	/* No useful relationship so no mapping */
 	return overflowuid;
@@ -118,12 +116,10 @@ gid_t user_ns_map_gid(struct user_namespace *to, const struct cred *cred, gid_t
 	/* Is cred->user the creator of the target user_ns
 	 * or the creator of one of it's parents?
 	 */
-	for ( tmp = to; tmp != &init_user_ns;
-	      tmp = tmp->creator->user_ns ) {
-		if (cred->user == tmp->creator) {
+	for (tmp = to; tmp != &init_user_ns;
+	      tmp = tmp->creator->user_ns)
+		if (cred->user == tmp->creator)
 			return (gid_t)0;
-		}
-	}
 
 	/* No useful relationship so no mapping */
 	return overflowgid;
-- 
1.7.4.4

