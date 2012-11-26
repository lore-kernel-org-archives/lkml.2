Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932780Ab2KZRFy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:05:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47464 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932684Ab2KZRFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:05:49 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 096/270] libceph: fix NULL dereference in reset_connection()
Date: Mon, 26 Nov 2012 14:56:26 -0200
Message-Id: <1353949160-26803-97-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 26ce171915f348abd1f41da1ed139d93750d987f upstream.

We dereference "con->in_msg" on the line after it was set to NULL.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/messenger.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index c52d587..0a6fdf8 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -440,7 +440,7 @@ static void reset_connection(struct ceph_connection *con)
 		con->in_msg->con = NULL;
 		ceph_msg_put(con->in_msg);
 		con->in_msg = NULL;
-		ceph_con_put(con->in_msg->con);
+		ceph_con_put(con);
 	}
 
 	con->connect_seq = 0;
-- 
1.7.9.5

