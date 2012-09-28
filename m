Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946130Ab2I1VNk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:13:40 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:57617 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759493Ab2I1Ukf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:40:35 -0400
X-Sasl-enc: bxKGhn7J+jbFXLVCFkUPKWykKoDpnAlk31eHBOxgYtzi 1348864831
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mathias Krause <minipli@googlemail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 012/127] Bluetooth: HCI - Fix info leak via getsockname()
Date: Fri, 28 Sep 2012 13:33:05 -0700
Message-Id: <20120928203047.252341508@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_sock.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -432,6 +432,7 @@ static int hci_sock_getname(struct socke
 	*addr_len = sizeof(*haddr);
 	haddr->hci_family = AF_BLUETOOTH;
 	haddr->hci_dev    = hdev->id;
+	haddr->hci_channel= 0;
 
 	release_sock(sk);
 	return 0;


