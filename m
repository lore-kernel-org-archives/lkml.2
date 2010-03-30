Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932783Ab0C3X0s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:26:48 -0400
Received: from kroah.org ([198.145.64.141]:46816 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756972Ab0C3XWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:22:12 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:54 2010
Message-Id: <20100330224854.069620492@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:42:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Lennart Schulte <lennart.schulte@nets.rwth-aachen.de>,
       Arnd Hannemann <hannemann@nets.rwth-aachen.de>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [144/156] tcp: Fix tcp_mark_head_lost() with packets == 0
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Lennart Schulte <lennart.schulte@nets.rwth-aachen.de>

[ Upstream commit 6830c25b7d08fbbd922959425193791bc42079f2 ]

A packet is marked as lost in case packets == 0, although nothing should be done.
This results in a too early retransmitted packet during recovery in some cases.
This small patch fixes this issue by returning immediately.

Signed-off-by: Lennart Schulte <lennart.schulte@nets.rwth-aachen.de>
Signed-off-by: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/tcp_input.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2499,6 +2499,9 @@ static void tcp_mark_head_lost(struct so
 	int err;
 	unsigned int mss;
 
+	if (packets == 0)
+		return;
+
 	WARN_ON(packets > tp->packets_out);
 	if (tp->lost_skb_hint) {
 		skb = tp->lost_skb_hint;


