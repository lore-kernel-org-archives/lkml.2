Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757154Ab0C3Xld (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:41:33 -0400
Received: from kroah.org ([198.145.64.141]:46253 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932619Ab0C3XUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:20:32 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:11 2010
Message-Id: <20100330224810.949988891@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:41:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Guo-Fu Tseng <cooldavid@cooldavid.org>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [078/156] jme: Fix VLAN memory leak
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Guo-Fu Tseng <cooldavid@cooldavid.org>

commit 17da69b8bfbe441a33a873ad5dd7d3d85800bf2b upstream.

Fix memory leak while receiving 8021q tagged packet which is not
registered by user.

Signed-off-by: Guo-Fu Tseng <cooldavid@cooldavid.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/jme.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/jme.c
+++ b/drivers/net/jme.c
@@ -946,6 +946,8 @@ jme_alloc_and_feed_skb(struct jme_adapte
 				jme->jme_vlan_rx(skb, jme->vlgrp,
 					le16_to_cpu(rxdesc->descwb.vlan));
 				NET_STAT(jme).rx_bytes += 4;
+			} else {
+				dev_kfree_skb(skb);
 			}
 		} else {
 			jme->jme_rx(skb);


