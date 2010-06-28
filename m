Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab0F1M6A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 08:58:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10869 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270Ab0F1M57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 08:57:59 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Bluetooth: Fix abuse of the preincrement operator
To: linux-bluetooth@vger.kernel.org
Cc: justinmattock@gmail.com, dhowells@redhat.com, linux-kernel@vger.kernel.org,
       gustavo@padovan.org
Date: Mon, 28 Jun 2010 13:57:52 +0100
Message-ID: <20100628125752.8945.50572.stgit@warthog.procyon.org.uk>
In-Reply-To: <1277621246-10960-6-git-send-email-justinmattock@gmail.com>
References: <1277621246-10960-6-git-send-email-justinmattock@gmail.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix abuse of the preincrement operator as detected when building with gcc
4.6.0:

	 CC [M]  drivers/bluetooth/hci_bcsp.o
	drivers/bluetooth/hci_bcsp.c: In function 'bcsp_prepare_pkt':
	drivers/bluetooth/hci_bcsp.c:247:20: warning: operation on 'bcsp->msgq_txseq' may be undefined

Reported-by: Justin P. Mattock <justinmattock@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/bluetooth/hci_bcsp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/bluetooth/hci_bcsp.c b/drivers/bluetooth/hci_bcsp.c
index 40aec0f..42d69d4 100644
--- a/drivers/bluetooth/hci_bcsp.c
+++ b/drivers/bluetooth/hci_bcsp.c
@@ -244,7 +244,7 @@ static struct sk_buff *bcsp_prepare_pkt(struct bcsp_struct *bcsp, u8 *data,
 	if (rel) {
 		hdr[0] |= 0x80 + bcsp->msgq_txseq;
 		BT_DBG("Sending packet with seqno %u", bcsp->msgq_txseq);
-		bcsp->msgq_txseq = ++(bcsp->msgq_txseq) & 0x07;
+		bcsp->msgq_txseq = (bcsp->msgq_txseq + 1) & 0x07;
 	}
 
 	if (bcsp->use_crc)

