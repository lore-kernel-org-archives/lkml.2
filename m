Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144Ab2KVVc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:32:26 -0500
Received: from mail.kernel.org ([198.145.19.201]:49611 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755171Ab2KVSkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Yehuda Sadeh <yehuda@inktank.com>
Subject: [ 094/171] libceph: kill bad_proto ceph connection op
Date: Wed, 21 Nov 2012 16:40:40 -0800
Message-Id: <20121122004042.793773136@linuxfoundation.org>
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

(cherry picked from commit 6384bb8b8e88a9c6bf2ae0d9517c2c0199177c34)

No code sets a bad_proto method in its ceph connection operations
vector, so just get rid of it.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Yehuda Sadeh <yehuda@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/ceph/messenger.h |    3 ---
 net/ceph/messenger.c           |    5 -----
 2 files changed, 8 deletions(-)

--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -31,9 +31,6 @@ struct ceph_connection_operations {
 	int (*verify_authorizer_reply) (struct ceph_connection *con, int len);
 	int (*invalidate_authorizer)(struct ceph_connection *con);
 
-	/* protocol version mismatch */
-	void (*bad_proto) (struct ceph_connection *con);
-
 	/* there was some error on the socket (disconnect, whatever) */
 	void (*fault) (struct ceph_connection *con);
 
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -1360,11 +1360,6 @@ static void fail_protocol(struct ceph_co
 {
 	reset_connection(con);
 	set_bit(CLOSED, &con->state);  /* in case there's queued work */
-
-	mutex_unlock(&con->mutex);
-	if (con->ops->bad_proto)
-		con->ops->bad_proto(con);
-	mutex_lock(&con->mutex);
 }
 
 static int process_connect(struct ceph_connection *con)


