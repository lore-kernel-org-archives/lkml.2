Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759359Ab0G3ReV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:34:21 -0400
Received: from kroah.org ([198.145.64.141]:35424 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759298Ab0G3Rdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:33:51 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:31:03 2010
Message-Id: <20100730173103.252264794@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:29:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [005/140] net: Fix FDDI and TR config checks in ipv4 arp and LLC.
In-Reply-To: <20100730173205.GA22581@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------


From: David S. Miller <davem@davemloft.net>

[ Upstream commit f0ecde1466f21edf577b809735f4f35f354777a0 ]

Need to check both CONFIG_FOO and CONFIG_FOO_MODULE

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/arp.c    |    6 +++---
 net/llc/llc_sap.c |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -619,13 +619,13 @@ struct sk_buff *arp_create(int type, int
 #endif
 #endif
 
-#ifdef CONFIG_FDDI
+#if defined(CONFIG_FDDI) || defined(CONFIG_FDDI_MODULE)
 	case ARPHRD_FDDI:
 		arp->ar_hrd = htons(ARPHRD_ETHER);
 		arp->ar_pro = htons(ETH_P_IP);
 		break;
 #endif
-#ifdef CONFIG_TR
+#if defined(CONFIG_TR) || defined(CONFIG_TR_MODULE)
 	case ARPHRD_IEEE802_TR:
 		arp->ar_hrd = htons(ARPHRD_IEEE802);
 		arp->ar_pro = htons(ETH_P_IP);
@@ -1005,7 +1005,7 @@ static int arp_req_set(struct net *net,
 			return -EINVAL;
 	}
 	switch (dev->type) {
-#ifdef CONFIG_FDDI
+#if defined(CONFIG_FDDI) || defined(CONFIG_FDDI_MODULE)
 	case ARPHRD_FDDI:
 		/*
 		 * According to RFC 1390, FDDI devices should accept ARP
--- a/net/llc/llc_sap.c
+++ b/net/llc/llc_sap.c
@@ -30,7 +30,7 @@ static int llc_mac_header_len(unsigned s
 	case ARPHRD_ETHER:
 	case ARPHRD_LOOPBACK:
 		return sizeof(struct ethhdr);
-#ifdef CONFIG_TR
+#if defined(CONFIG_TR) || defined(CONFIG_TR_MODULE)
 	case ARPHRD_IEEE802_TR:
 		return sizeof(struct trh_hdr);
 #endif


