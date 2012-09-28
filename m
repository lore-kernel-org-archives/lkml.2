Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758789Ab2I1Sya (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 14:54:30 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:63190 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758757Ab2I1SyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:54:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mathias Krause <minipli@googlemail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 014/262] Bluetooth: HCI - Fix info leak via getsockname()
Date: Fri, 28 Sep 2012 11:49:03 -0700
Message-Id: <20120928182959.638712352@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
@@ -706,6 +706,7 @@ static int hci_sock_getname(struct socke
 	*addr_len = sizeof(*haddr);
 	haddr->hci_family = AF_BLUETOOTH;
 	haddr->hci_dev    = hdev->id;
+	haddr->hci_channel= 0;
 
 	release_sock(sk);
 	return 0;


