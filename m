Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab2IQBCz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 21:02:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33813 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753151Ab2IQAvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:51:09 -0400
Message-Id: <20120917003634.543602867@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:37:25 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mathias Krause <minipli@googlemail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 060/135] Bluetooth: HCI - Fix info leak via getsockname()
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit 3f68ba07b1da811bf383b4b701b129bfcb2e4988 ]

The HCI code fails to initialize the hci_channel member of struct
sockaddr_hci and that for leaks two bytes kernel stack via the
getsockname() syscall. Initialize hci_channel with 0 to avoid the
info leak.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Gustavo Padovan <gustavo@padovan.org>
Cc: Johan Hedberg <johan.hedberg@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/bluetooth/hci_sock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index e4c8bc0..8361ee4 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -388,6 +388,7 @@ static int hci_sock_getname(struct socket *sock, struct sockaddr *addr, int *add
 	*addr_len = sizeof(*haddr);
 	haddr->hci_family = AF_BLUETOOTH;
 	haddr->hci_dev    = hdev->id;
+	haddr->hci_channel= 0;
 
 	release_sock(sk);
 	return 0;


