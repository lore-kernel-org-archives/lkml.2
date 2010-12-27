Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab0L0SAS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 13:00:18 -0500
Received: from cantor.suse.de ([195.135.220.2]:53680 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263Ab0L0SAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 13:00:17 -0500
From: David Sterba <dsterba@suse.cz>
To: padovan@profusion.mobi
Cc: linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Sterba <dsterba@suse.cz>,
        Marcel Holtmann <marcel@holtmann.org>,
        =?UTF-8?q?Jo=C3=A3o=20Paulo=20Rechi=20Vita?= 
	<jprvita@profusion.mobi>
Subject: [PATCH] Bluetooth: l2cap: fix misuse of logical operation in place of bitop
Date: Mon, 27 Dec 2010 19:00:10 +0100
Message-Id: <1293472810-30233-1-git-send-email-dsterba@suse.cz>
X-Mailer: git-send-email 1.7.3.4.626.g73e7b
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

