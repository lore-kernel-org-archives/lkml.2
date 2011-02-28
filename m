Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab1B1N1t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 08:27:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653Ab1B1N1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 08:27:48 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] AF_RXRPC: Handle receiving ACKALL packets
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Mon, 28 Feb 2011 13:27:43 +0000
Message-ID: <20110228132743.30463.33897.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The OpenAFS server is now sending ACKALL packets, so we need to handle them.
Otherwise we report a protocol error and abort.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/ar-input.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/rxrpc/ar-input.c b/net/rxrpc/ar-input.c
index a4fc974..996d3ef 100644
--- a/net/rxrpc/ar-input.c
+++ b/net/rxrpc/ar-input.c
@@ -423,6 +423,7 @@ void rxrpc_fast_process_packet(struct rxrpc_call *call, struct sk_buff *skb)
 			goto protocol_error;
 		}
 
+	case RXRPC_PACKET_TYPE_ACKALL:
 	case RXRPC_PACKET_TYPE_ACK:
 		/* ACK processing is done in process context */
 		read_lock_bh(&call->state_lock);

