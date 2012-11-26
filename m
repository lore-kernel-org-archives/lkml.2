Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933220Ab2KZRIL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:08:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47619 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933202Ab2KZRIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:08:05 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sage Weil <sage@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 132/270] libceph: drop unnecessary CLOSED check in socket state change callback
Date: Mon, 26 Nov 2012 14:57:02 -0200
Message-Id: <1353949160-26803-133-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

commit d7353dd5aaf22ed611fbcd0d4a4a12fb30659290 upstream.

If we are CLOSED, the socket is closed and we won't get these.

Signed-off-by: Sage Weil <sage@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/messenger.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 46ce113..e7320cd 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -296,9 +296,6 @@ static void ceph_sock_state_change(struct sock *sk)
 	dout("%s %p state = %lu sk_state = %u\n", __func__,
 	     con, con->state, sk->sk_state);
 
-	if (test_bit(CLOSED, &con->state))
-		return;
-
 	switch (sk->sk_state) {
 	case TCP_CLOSE:
 		dout("%s TCP_CLOSE\n", __func__);
-- 
1.7.9.5

