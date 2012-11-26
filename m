Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384Ab2KZREZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:04:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47372 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932359Ab2KZREU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:04:20 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Elder <elder@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 074/270] libceph: eliminate connection state "DEAD"
Date: Mon, 26 Nov 2012 14:56:04 -0200
Message-Id: <1353949160-26803-75-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

commit e5e372da9a469dfe3ece40277090a7056c566838 upstream.

The ceph connection state "DEAD" is never set and is therefore not
needed.  Eliminate it.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Yehuda Sadeh <yehuda@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 include/linux/ceph/messenger.h |    1 -
 net/ceph/messenger.c           |    6 ------
 2 files changed, 7 deletions(-)

diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index 44c87e7..6a1dc80 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -119,7 +119,6 @@ struct ceph_msg_pos {
 #define CLOSED		10 /* we've closed the connection */
 #define SOCK_CLOSED	11 /* socket state changed to closed */
 #define OPENING         13 /* open connection w/ (possibly new) peer */
-#define DEAD            14 /* dead, about to kfree */
 #define BACKOFF         15
 
 /*
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 10255e8..ad2eaad 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -2091,12 +2091,6 @@ bad_tag:
  */
 static void queue_con(struct ceph_connection *con)
 {
-	if (test_bit(DEAD, &con->state)) {
-		dout("queue_con %p ignoring: DEAD\n",
-		     con);
-		return;
-	}
-
 	if (!con->ops->get(con)) {
 		dout("queue_con %p ref count 0\n", con);
 		return;
-- 
1.7.9.5

