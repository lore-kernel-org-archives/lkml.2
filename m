Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442Ab2HOVdK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 17:33:10 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34449 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756446Ab2HOVdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 17:33:03 -0400
From: Mathias Krause <minipli@googlemail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>
Subject: [PATCH 04/14] Bluetooth: HCI - Fix info leak via getsockname()
Date: Wed, 15 Aug 2012 23:31:47 +0200
Message-Id: <1345066317-22512-5-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1345066317-22512-1-git-send-email-minipli@googlemail.com>
References: <1345066317-22512-1-git-send-email-minipli@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The HCI code fails to initialize the hci_channel member of struct
sockaddr_hci and that for leaks two bytes kernel stack via the
getsockname() syscall. Initialize hci_channel with 0 to avoid the
info leak.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Gustavo Padovan <gustavo@padovan.org>
Cc: Johan Hedberg <johan.hedberg@gmail.com>
---
 net/bluetooth/hci_sock.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index a27bbc3..19fdac7 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -694,6 +694,7 @@ static int hci_sock_getname(struct socket *sock, struct sockaddr *addr,
 	*addr_len = sizeof(*haddr);
 	haddr->hci_family = AF_BLUETOOTH;
 	haddr->hci_dev    = hdev->id;
+	haddr->hci_channel= 0;
 
 	release_sock(sk);
 	return 0;
-- 
1.7.10.4

