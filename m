Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932718Ab2FGETc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:19:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62777 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932696Ab2FGET2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:19:28 -0400
Message-Id: <20120607040344.002169511@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:04:29 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Dumazet <edumazet@google.com>,
        Allan Chou <allan@asix.com.tw>, Trond Wuellner <trond@chromium.org>,
        Grant Grundler <grundler@chromium.org>,
        Paul Stewart <pstew@chromium.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 53/82] asix: allow full size 8021Q frames to be received
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 9dae31009b1a00d926c6fe032d5a88099620adc3 ]

asix driver drops 8021Q full size frames because it doesn't take into
account VLAN header size.

Tested on AX88772 adapter.

Signed-off-by: Eric Dumazet <edumazet@google.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Allan Chou <allan@asix.com.tw>
CC: Trond Wuellner <trond@chromium.org>
CC: Grant Grundler <grundler@chromium.org>
CC: Paul Stewart <pstew@chromium.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/asix.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/usb/asix.c
+++ b/drivers/net/usb/asix.c
@@ -35,6 +35,7 @@
 #include <linux/crc32.h>
 #include <linux/usb/usbnet.h>
 #include <linux/slab.h>
+#include <linux/if_vlan.h>
 
 #define DRIVER_VERSION "22-Dec-2011"
 #define DRIVER_NAME "asix"
@@ -321,7 +322,7 @@ static int asix_rx_fixup(struct usbnet *
 			return 0;
 		}
 
-		if ((size > dev->net->mtu + ETH_HLEN) ||
+		if ((size > dev->net->mtu + ETH_HLEN + VLAN_HLEN) ||
 		    (size + offset > skb->len)) {
 			netdev_err(dev->net, "asix_rx_fixup() Bad RX Length %d\n",
 				   size);


