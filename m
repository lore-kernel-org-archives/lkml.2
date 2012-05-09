Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808Ab2EIGJL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:09:11 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39173 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756737Ab2EIFxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:34 -0400
Message-Id: <20120509055052.587401183@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:53:16 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Paolo Pisati <paolo.pisati@canonical.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 167/167] [PATCH] smsc95xx: mark link down on startup and let PHY interrupt
 deal with carrier changes
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Pisati <paolo.pisati@canonical.com>

commit 07d69d4238418746a7b85c5d05ec17c658a2a390 upstream.

Without this patch sysfs reports the cable as present

flag@flag-desktop:~$ cat /sys/class/net/eth0/carrier
1

while it's not:

flag@flag-desktop:~$ sudo mii-tool eth0
eth0: no link

Tested on my Beagle XM.

v2: added mantainer to the list of recipient

Signed-off-by: Paolo Pisati <paolo.pisati@canonical.com>
Acked-by: Steve Glendinning <steve.glendinning@shawell.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/usb/smsc95xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index 53a1ba5..94ae669 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -1192,7 +1192,7 @@ static const struct driver_info smsc95xx_info = {
 	.rx_fixup	= smsc95xx_rx_fixup,
 	.tx_fixup	= smsc95xx_tx_fixup,
 	.status		= smsc95xx_status,
-	.flags		= FLAG_ETHER | FLAG_SEND_ZLP,
+	.flags		= FLAG_ETHER | FLAG_SEND_ZLP | FLAG_LINK_INTR,
 };
 
 static const struct usb_device_id products[] = {
-- 
1.7.10



