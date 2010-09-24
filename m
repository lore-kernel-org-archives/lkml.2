Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895Ab0IXQjc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:39:32 -0400
Received: from kroah.org ([198.145.64.141]:37391 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933108Ab0IXQfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:35:44 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:33:48 2010
Message-Id: <20100924163348.568967991@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:32:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vlad Yasevich <vladislav.yasevich@hp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [51/68] sctp: Do not reset the packet during sctp_packet_config().
In-Reply-To: <20100924163357.GA15741@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vlad Yasevich <vladislav.yasevich@hp.com>

commit 4bdab43323b459900578b200a4b8cf9713ac8fab upstream.

sctp_packet_config() is called when getting the packet ready
for appending of chunks.  The function should not touch the
current state, since it's possible to ping-pong between two
transports when sending, and that can result packet corruption
followed by skb overlfow crash.

Reported-by: Thomas Dreibholz <dreibh@iem.uni-due.de>
Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sctp/output.c |    1 -
 1 file changed, 1 deletion(-)

--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -91,7 +91,6 @@ struct sctp_packet *sctp_packet_config(s
 	SCTP_DEBUG_PRINTK("%s: packet:%p vtag:0x%x\n", __func__,
 			  packet, vtag);
 
-	sctp_packet_reset(packet);
 	packet->vtag = vtag;
 
 	if (ecn_capable && sctp_packet_empty(packet)) {


