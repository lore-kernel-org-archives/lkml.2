Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029Ab2KZRva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:51:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47631 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932853Ab2KZRIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:08:17 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sage Weil <sage@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 135/270] libceph: clear all flags on con_close
Date: Mon, 26 Nov 2012 14:57:05 -0200
Message-Id: <1353949160-26803-136-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

commit 43c7427d100769451601b8a36988ac0528ce0124 upstream.

Signed-off-by: Sage Weil <sage@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/messenger.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index b872db5..fa16f2c 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -528,6 +528,8 @@ void ceph_con_close(struct ceph_connection *con)
 	clear_bit(CON_FLAG_LOSSYTX, &con->flags); /* so we retry next connect */
 	clear_bit(CON_FLAG_KEEPALIVE_PENDING, &con->flags);
 	clear_bit(CON_FLAG_WRITE_PENDING, &con->flags);
+	clear_bit(CON_FLAG_KEEPALIVE_PENDING, &con->flags);
+	clear_bit(CON_FLAG_BACKOFF, &con->flags);
 
 	reset_connection(con);
 	con->peer_global_seq = 0;
-- 
1.7.9.5

