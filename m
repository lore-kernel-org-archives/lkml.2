Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761835Ab2FHFM4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:12:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43338 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761375Ab2FHFHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:31 -0400
Message-Id: <20120608041851.957364366@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:20:02 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Dumazet <edumazet@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Allan Chou <allan@asix.com.tw>, Trond Wuellner <trond@chromium.org>,
        Grant Grundler <grundler@chromium.org>,
        Paul Stewart <pstew@chromium.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 82/82] asix: allow full size 8021Q frames to be received
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 9dae31009b1a00d926c6fe032d5a88099620adc3 upstream.

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
[bwh: Backported to 3.2: no offset used in asix_rx_fixup()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/net/usb/asix.c
+++ b/drivers/net/usb/asix.c
@@ -35,6 +35,7 @@
 #include <linux/crc32.h>
 #include <linux/usb/usbnet.h>
 #include <linux/slab.h>
+#include <linux/if_vlan.h>
 
 #define DRIVER_VERSION "08-Nov-2011"
 #define DRIVER_NAME "asix"
@@ -348,7 +349,7 @@
 			return 2;
 		}
 
-		if (size > dev->net->mtu + ETH_HLEN) {
+		if (size > dev->net->mtu + ETH_HLEN + VLAN_HLEN) {
 			netdev_err(dev->net, "asix_rx_fixup() Bad RX Length %d\n",
 				   size);
 			return 0;


