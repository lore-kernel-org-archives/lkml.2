Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104Ab2KVV7k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:59:40 -0500
Received: from mail.kernel.org ([198.145.19.201]:49610 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754883Ab2KVSkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Yehuda Sadeh <yehuda@inktank.com>
Subject: [ 093/171] libceph: eliminate connection state "DEAD"
Date: Wed, 21 Nov 2012 16:40:39 -0800
Message-Id: <20121122004042.692831800@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

(cherry picked from commit e5e372da9a469dfe3ece40277090a7056c566838)

The ceph connection state "DEAD" is never set and is therefore not
needed.  Eliminate it.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Yehuda Sadeh <yehuda@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/ceph/messenger.h |    1 -
 net/ceph/messenger.c           |    6 ------
 2 files changed, 7 deletions(-)

--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -119,7 +119,6 @@ struct ceph_msg_pos {
 #define CLOSED		10 /* we've closed the connection */
 #define SOCK_CLOSED	11 /* socket state changed to closed */
 #define OPENING         13 /* open connection w/ (possibly new) peer */
-#define DEAD            14 /* dead, about to kfree */
 #define BACKOFF         15
 
 /*
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


