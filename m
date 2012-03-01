Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab2CARR2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 12:17:28 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64577 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab2CARR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 12:17:26 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of santoshprasadnayak@gmail.com designates 10.68.125.133 as permitted sender) smtp.mail=santoshprasadnayak@gmail.com; dkim=pass header.i=santoshprasadnayak@gmail.com
From: santosh nayak <santoshprasadnayak@gmail.com>
To: marcel@holtmann.org
Cc: padovan@profusion.mobi, davem@davemloft.net,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Santosh Nayak <santoshprasadnayak@gmail.com>
Subject: Resend: [PATCH] Bluetooth: Fix Endian Bug.
Date: Thu,  1 Mar 2012 22:46:36 +0530
Message-Id: <1330622196-12967-1-git-send-email-santoshprasadnayak@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Santosh Nayak <santoshprasadnayak@gmail.com>

Fix network to host endian conversion for L2CAP chan id.

Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
---
 net/bluetooth/l2cap_sock.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index 401d942..86d5067 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -82,7 +82,7 @@ static int l2cap_sock_bind(struct socket *sock, struct sockaddr *addr, int alen)
 	}
 
 	if (la.l2_cid)
-		err = l2cap_add_scid(chan, la.l2_cid);
+		err = l2cap_add_scid(chan, __le16_to_cpu(la.l2_cid));
 	else
 		err = l2cap_add_psm(chan, &la.l2_bdaddr, la.l2_psm);
 
@@ -123,7 +123,8 @@ static int l2cap_sock_connect(struct socket *sock, struct sockaddr *addr, int al
 	if (la.l2_cid && la.l2_psm)
 		return -EINVAL;
 
-	err = l2cap_chan_connect(chan, la.l2_psm, la.l2_cid, &la.l2_bdaddr);
+	err = l2cap_chan_connect(chan, la.l2_psm, __le16_to_cpu(la.l2_cid),
+				&la.l2_bdaddr);
 	if (err)
 		goto done;
 
-- 
1.7.4.4

