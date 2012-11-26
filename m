Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136Ab2KZR4z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:56:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47544 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933030Ab2KZRHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:07:04 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Elder <elder@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 115/270] libceph: add some fine ASCII art
Date: Mon, 26 Nov 2012 14:56:45 -0200
Message-Id: <1353949160-26803-116-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

commit bc18f4b1c850ab355e38373fbb60fd28568d84b5 upstream.

Sage liked the state diagram I put in my commit description so
I'm putting it in with the code.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/messenger.c |   42 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 64db2c2..dfc4192 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -29,7 +29,47 @@
  * the sender.
  */
 
-/* State values for ceph_connection->sock_state; NEW is assumed to be 0 */
+/*
+ * We track the state of the socket on a given connection using
+ * values defined below.  The transition to a new socket state is
+ * handled by a function which verifies we aren't coming from an
+ * unexpected state.
+ *
+ *      --------
+ *      | NEW* |  transient initial state
+ *      --------
+ *          | con_sock_state_init()
+ *          v
+ *      ----------
+ *      | CLOSED |  initialized, but no socket (and no
+ *      ----------  TCP connection)
+ *       ^      \
+ *       |       \ con_sock_state_connecting()
+ *       |        ----------------------
+ *       |                              \
+ *       + con_sock_state_closed()       \
+ *       |\                               \
+ *       | \                               \
+ *       |  -----------                     \
+ *       |  | CLOSING |  socket event;       \
+ *       |  -----------  await close          \
+ *       |       ^                            |
+ *       |       |                            |
+ *       |       + con_sock_state_closing()   |
+ *       |      / \                           |
+ *       |     /   ---------------            |
+ *       |    /                   \           v
+ *       |   /                    --------------
+ *       |  /    -----------------| CONNECTING |  socket created, TCP
+ *       |  |   /                 --------------  connect initiated
+ *       |  |   | con_sock_state_connected()
+ *       |  |   v
+ *      -------------
+ *      | CONNECTED |  TCP connection established
+ *      -------------
+ *
+ * State values for ceph_connection->sock_state; NEW is assumed to be 0.
+ */
 
 #define CON_SOCK_STATE_NEW		0	/* -> CLOSED */
 #define CON_SOCK_STATE_CLOSED		1	/* -> CONNECTING */
-- 
1.7.9.5

