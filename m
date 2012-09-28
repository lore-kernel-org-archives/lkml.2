Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946106Ab2I1VMr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:12:47 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56918 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759510Ab2I1Ukj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:40:39 -0400
X-Sasl-enc: C/zXgtgMCzobXfQStja4AvrV7V8SEK6f6z5qyiNKXTHz 1348864838
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mathias Krause <minipli@googlemail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 015/127] Bluetooth: L2CAP - Fix info leak via getsockname()
Date: Fri, 28 Sep 2012 13:33:08 -0700
Message-Id: <20120928203047.577337871@linuxfoundation.org>
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

[ Upstream commit 792039c73cf176c8e39a6e8beef2c94ff46522ed ]

The L2CAP code fails to initialize the l2_bdaddr_type member of struct
sockaddr_l2 and the padding byte added for alignment. It that for leaks
two bytes kernel stack via the getsockname() syscall. Add an explicit
memset(0) before filling the structure to avoid the info leak.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Gustavo Padovan <gustavo@padovan.org>
Cc: Johan Hedberg <johan.hedberg@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_sock.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -329,6 +329,7 @@ static int l2cap_sock_getname(struct soc
 
 	BT_DBG("sock %p, sk %p", sock, sk);
 
+	memset(la, 0, sizeof(struct sockaddr_l2));
 	addr->sa_family = AF_BLUETOOTH;
 	*len = sizeof(struct sockaddr_l2);
 


