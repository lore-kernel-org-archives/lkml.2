Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332Ab2KVVhN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:37:13 -0500
Received: from mail.kernel.org ([198.145.19.201]:49609 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755086Ab2KVSk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 134/171] libceph: add some fine ASCII art
Date: Wed, 21 Nov 2012 16:41:20 -0800
Message-Id: <20121122004046.801691277@linuxfoundation.org>
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

(cherry picked from commit bc18f4b1c850ab355e38373fbb60fd28568d84b5)

Sage liked the state diagram I put in my commit description so
I'm putting it in with the code.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |   42 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

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


