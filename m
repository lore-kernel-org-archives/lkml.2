Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758966Ab0KPBOk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 20:14:40 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47964 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab0KPBOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 20:14:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=RpeLkxCMkiOoR42SvK68a4D3vl0S4MiGpQKJCXJHheyGdTMns6hHViqrszs685jFiV
         K3qdu/hZ6FjOi/Ym2+NgOhtGGfsjTRQ4jnRVdh0mSqbMdpUQJ/byDlWP66o8ADmxxWno
         wZDxE6VjnJFZg4giPAW4lpDCoSbNs2Wxh3n7A=
From: Audun Hoem <audun.hoem@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Audun Hoem <audun.hoem@gmail.com>
Subject: [PATCH] staging: bcm: Arp.c: Checkpatch.pl fix
Date: Tue, 16 Nov 2010 02:14:03 +0100
Message-Id: <1289870043-18819-1-git-send-email-audun.hoem@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleaned up the coding style. 80 line length limit warnings are in a comment.

Signed-off-by: Audun Hoem <audun.hoem@gmail.com>
---
 drivers/staging/bcm/Arp.c |   63 ++++++++++++++++++++------------------------
 1 files changed, 29 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/bcm/Arp.c b/drivers/staging/bcm/Arp.c
index d60d859..6526270 100644
--- a/drivers/staging/bcm/Arp.c
+++ b/drivers/staging/bcm/Arp.c
@@ -10,57 +10,52 @@
  * Function    - reply_to_arp_request()
  *
  * Description - When this host tries to broadcast ARP request packet through
- *		 		 the virtual interface (veth0), reply directly to upper layer.
- *		 		 This function allocates a new skb for ARP reply packet,
- *		 		 fills in the fields of the packet and then sends it to
- *		 		 upper layer.
+ *				the virtual interface (veth0), reply directly to upper layer.
+ *				This function allocates a new skb for ARP reply packet,
+ *				fills in the fields of the packet and then sends it to
+ *				upper layer.
  *
  * Parameters  - skb:	Pointer to sk_buff structure of the ARP request pkt.
  *
  * Returns     - None
  * =========================================================================*/
 
-VOID
-reply_to_arp_request(struct sk_buff *skb)
+void reply_to_arp_request(struct sk_buff *skb)
 {
-	PMINI_ADAPTER		Adapter;
-	struct ArpHeader 	*pArpHdr = NULL;
-	struct ethhdr		*pethhdr = NULL;
-	UCHAR 				uiIPHdr[4];
+	PMINI_ADAPTER Adapter;
+	struct ArpHeader *pArpHdr = NULL;
+	struct ethhdr *pethhdr = NULL;
+	UCHAR  uiIPHdr[4];
 	/* Check for valid skb */
-	if(skb == NULL)
-	{
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0, "Invalid skb: Cannot reply to ARP request\n");
+	if (skb == NULL) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Invalid skb: Cannot reply to ARP request\n");
 		return;
 	}
 
 
 	Adapter = GET_BCM_ADAPTER(skb->dev);
 	/* Print the ARP Request Packet */
-	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, ARP_RESP, DBG_LVL_ALL, "ARP Packet Dump :");
-	BCM_DEBUG_PRINT_BUFFER(Adapter,DBG_TYPE_TX, ARP_RESP, DBG_LVL_ALL, (PUCHAR)(skb->data), skb->len);
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, ARP_RESP, DBG_LVL_ALL, "ARP Packet Dump :");
+	BCM_DEBUG_PRINT_BUFFER(Adapter, DBG_TYPE_TX, ARP_RESP, DBG_LVL_ALL, (PUCHAR)(skb->data), skb->len);
 
 	/*
 	 * Extract the Ethernet Header and Arp Payload including Header
-     */
+	 */
 	pethhdr = (struct ethhdr *)skb->data;
 	pArpHdr  = (struct ArpHeader *)(skb->data+ETH_HLEN);
 
-	if(Adapter->bETHCSEnabled)
-	{
-		if(memcmp(pethhdr->h_source, Adapter->dev->dev_addr, ETH_ALEN))
-		{
+	if (Adapter->bETHCSEnabled) {
+		if (memcmp(pethhdr->h_source, Adapter->dev->dev_addr, ETH_ALEN)) {
 			bcm_kfree_skb(skb);
 			return;
 		}
 	}
 
-	// Set the Ethernet Header First.
+	/* Set the Ethernet Header First. */
 	memcpy(pethhdr->h_dest, pethhdr->h_source, ETH_ALEN);
-	if(!memcmp(pethhdr->h_source, Adapter->dev->dev_addr, ETH_ALEN))
-	{
+	if (!memcmp(pethhdr->h_source, Adapter->dev->dev_addr, ETH_ALEN))
 		pethhdr->h_source[5]++;
-	}
+
 
 	/* Set the reply to ARP Reply */
 	pArpHdr->arp.ar_op = ntohs(ARPOP_REPLY);
@@ -69,25 +64,25 @@ reply_to_arp_request(struct sk_buff *skb)
 	memcpy(pArpHdr->ar_sha, pethhdr->h_source, ETH_ALEN);
 	memcpy(pArpHdr->ar_tha, pethhdr->h_dest, ETH_ALEN);
 
-	// Swapping the IP Adddress
-	memcpy(uiIPHdr,pArpHdr->ar_sip,4);
-	memcpy(pArpHdr->ar_sip,pArpHdr->ar_tip,4);
-	memcpy(pArpHdr->ar_tip,uiIPHdr,4);
+	/* Swapping the IP Adddress */
+	memcpy(uiIPHdr, pArpHdr->ar_sip, 4);
+	memcpy(pArpHdr->ar_sip, pArpHdr->ar_tip, 4);
+	memcpy(pArpHdr->ar_tip, uiIPHdr, 4);
 
 	/* Print the ARP Reply Packet */
 
-	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, ARP_RESP, DBG_LVL_ALL, "ARP REPLY PACKET: ");
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, ARP_RESP, DBG_LVL_ALL, "ARP REPLY PACKET: ");
 
 	/* Send the Packet to upper layer */
-	BCM_DEBUG_PRINT_BUFFER(Adapter,DBG_TYPE_TX, ARP_RESP, DBG_LVL_ALL, (PUCHAR)(skb->data), skb->len);
+	BCM_DEBUG_PRINT_BUFFER(Adapter, DBG_TYPE_TX, ARP_RESP, DBG_LVL_ALL, (PUCHAR)(skb->data), skb->len);
 
-	skb->protocol = eth_type_trans(skb,skb->dev);
+	skb->protocol = eth_type_trans(skb, skb->dev);
 	skb->pkt_type = PACKET_HOST;
 
-//	skb->mac.raw=skb->data+LEADER_SIZE;
-	skb_set_mac_header (skb, LEADER_SIZE);
+	/* skb->mac.raw=skb->data+LEADER_SIZE; */
+	skb_set_mac_header(skb, LEADER_SIZE);
 	netif_rx(skb);
-	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_TX, ARP_RESP, DBG_LVL_ALL, "<=============\n");
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, ARP_RESP, DBG_LVL_ALL, "<=============\n");
 	return;
 }
 
-- 
1.7.0.4

