Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757815Ab1ANOAF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 09:00:05 -0500
Received: from cantor.suse.de ([195.135.220.2]:39087 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757717Ab1ANN7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 08:59:53 -0500
From: David Sterba <dsterba@suse.cz>
To: akpm@linux-foundation.org
Cc: marcel@holtmann.org, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Sterba <dsterba@suse.cz>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        =?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?= 
	<jprvita@profusion.mobi>
Subject: [PATCH resend] Bluetooth: l2cap: fix misuse of logical operation in place of bitop
Date: Fri, 14 Jan 2011 14:59:44 +0100
Message-Id: <1295013584-15592-1-git-send-email-dsterba@suse.cz>
X-Mailer: git-send-email 1.7.4.rc2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Marcel Holtmann <marcel@holtmann.org>
CC: "Gustavo F. Padovan" <padovan@profusion.mobi>
CC: João Paulo Rechi Vita <jprvita@profusion.mobi>
Signed-off-by: David Sterba <dsterba@suse.cz>
---

Andrew, this has not been picked up by maintainers since 27.12., please consider it for -mm.

 net/bluetooth/l2cap.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/l2cap.c b/net/bluetooth/l2cap.c
index cd8f6ea..bdfdfdc 100644
--- a/net/bluetooth/l2cap.c
+++ b/net/bluetooth/l2cap.c
@@ -1893,8 +1893,8 @@ static int l2cap_sock_sendmsg(struct kiocb *iocb, struct socket *sock, struct ms
 		if (pi->mode == L2CAP_MODE_STREAMING) {
 			l2cap_streaming_send(sk);
 		} else {
-			if (pi->conn_state & L2CAP_CONN_REMOTE_BUSY &&
-					pi->conn_state && L2CAP_CONN_WAIT_F) {
+			if ((pi->conn_state & L2CAP_CONN_REMOTE_BUSY) &&
+					(pi->conn_state & L2CAP_CONN_WAIT_F)) {
 				err = len;
 				break;
 			}
-- 
1.7.3.4.626.g73e7b

