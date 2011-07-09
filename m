Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364Ab1GIBEz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 21:04:55 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:47364 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab1GIBEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 21:04:54 -0400
From: Daniel Baluta <dbaluta@ixiacom.com>
To: davem@davemloft.net
Cc: eric.dumazet@gmail.com, richard.cochran@omicron.at,
        mirq-linux@rere.qmqm.pl, xiaosuo@gmail.com,
        linux-kernel@vger.kernel.org, Daniel Baluta <dbaluta@ixiacom.com>
Subject: [PATCH] skbuff: update struct sk_buff members comments
Date: Sat,  9 Jul 2011 04:03:28 +0300
Message-Id: <1310173408-7727-1-git-send-email-dbaluta@ixiacom.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rearrange struct sk_buff members comments to follow their
definition order. Also, add missing comments for ooo_okay
and dropcount members.

Signed-off-by: Daniel Baluta <dbaluta@ixiacom.com>
---
 include/linux/skbuff.h |   42 ++++++++++++++++++++++--------------------
 1 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 08d4507..00979a3 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -285,15 +285,12 @@ typedef unsigned char *sk_buff_data_t;
  *	struct sk_buff - socket buffer
  *	@next: Next buffer in list
  *	@prev: Previous buffer in list
- *	@sk: Socket we are owned by
  *	@tstamp: Time we arrived
+ *	@sk: Socket we are owned by
  *	@dev: Device we arrived on/are leaving by
- *	@transport_header: Transport layer header
- *	@network_header: Network layer header
- *	@mac_header: Link layer header
+ *	@cb: Control buffer. Free for use by every layer. Put private vars here
  *	@_skb_refdst: destination entry (with norefcount bit)
  *	@sp: the security path, used for xfrm
- *	@cb: Control buffer. Free for use by every layer. Put private vars here
  *	@len: Length of actual data
  *	@data_len: Data length
  *	@mac_len: Length of link layer header
@@ -301,40 +298,45 @@ typedef unsigned char *sk_buff_data_t;
  *	@csum: Checksum (must include start/offset pair)
  *	@csum_start: Offset from skb->head where checksumming should start
  *	@csum_offset: Offset from csum_start where checksum should be stored
+ *	@priority: Packet queueing priority
  *	@local_df: allow local fragmentation
  *	@cloned: Head may be cloned (check refcnt to be sure)
+ *	@ip_summed: Driver fed us an IP checksum
  *	@nohdr: Payload reference only, must not modify header
+ *	@nfctinfo: Relationship of this skb to the connection
  *	@pkt_type: Packet class
  *	@fclone: skbuff clone status
- *	@ip_summed: Driver fed us an IP checksum
- *	@priority: Packet queueing priority
- *	@users: User count - see {datagram,tcp}.c
- *	@protocol: Packet protocol from driver
- *	@truesize: Buffer size 
- *	@head: Head of buffer
- *	@data: Data head pointer
- *	@tail: Tail pointer
- *	@end: End pointer
- *	@destructor: Destruct function
- *	@mark: Generic packet mark
- *	@nfct: Associated connection, if any
  *	@ipvs_property: skbuff is owned by ipvs
  *	@peeked: this packet has been seen already, so stats have been
  *		done for it, don't do them again
  *	@nf_trace: netfilter packet trace flag
- *	@nfctinfo: Relationship of this skb to the connection
+ *	@protocol: Packet protocol from driver
+ *	@destructor: Destruct function
+ *	@nfct: Associated connection, if any
  *	@nfct_reasm: netfilter conntrack re-assembly pointer
  *	@nf_bridge: Saved data about a bridged frame - see br_netfilter.c
  *	@skb_iif: ifindex of device we arrived on
- *	@rxhash: the packet hash computed on receive
- *	@queue_mapping: Queue mapping for multiqueue devices
  *	@tc_index: Traffic control index
  *	@tc_verd: traffic control verdict
+ *	@rxhash: the packet hash computed on receive
+ *	@queue_mapping: Queue mapping for multiqueue devices
  *	@ndisc_nodetype: router type (from link layer)
+ *	@ooo_okay: allow the mapping of a socket to a queue to be changed
  *	@dma_cookie: a cookie to one of several possible DMA operations
  *		done by skb DMA functions
  *	@secmark: security marking
+ *	@mark: Generic packet mark
+ *	@dropcount: total number of sk_receive_queue overflows
  *	@vlan_tci: vlan tag control information
+ *	@transport_header: Transport layer header
+ *	@network_header: Network layer header
+ *	@mac_header: Link layer header
+ *	@tail: Tail pointer
+ *	@end: End pointer
+ *	@head: Head of buffer
+ *	@data: Data head pointer
+ *	@truesize: Buffer size
+ *	@users: User count - see {datagram,tcp}.c
  */
 
 struct sk_buff {
-- 
1.7.1

