Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946172Ab2ERXCn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:02:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53524 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968181Ab2ERXCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:02:41 -0400
Message-Id: <20120518211559.552795609@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 18 May 2012 14:16:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Paolo Pisati <paolo.pisati@canonical.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 01/54] smsc95xx: mark link down on startup and let PHY interrupt
 deal with carrier changes
In-Reply-To: <20120518212656.GA4992@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/usb/smsc95xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -1190,7 +1190,7 @@ static const struct driver_info smsc95xx
 	.rx_fixup	= smsc95xx_rx_fixup,
 	.tx_fixup	= smsc95xx_tx_fixup,
 	.status		= smsc95xx_status,
-	.flags		= FLAG_ETHER | FLAG_SEND_ZLP,
+	.flags		= FLAG_ETHER | FLAG_SEND_ZLP | FLAG_LINK_INTR,
 };
 
 static const struct usb_device_id products[] = {


