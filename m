Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935013Ab1KJD2v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:28:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42552 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934999Ab1KJD2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:28:46 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:17 2011
Message-Id: <20111109212716.994350488@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:28:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Huajun Li <huajun.li.lee@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [163/262] rtl8150: rtl8150_disconnect(...) does not need tasklet_disable(...)
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: huajun li <huajun.li.lee@gmail.com>

commit c2e2a313ff8fdc25cedef5e63da712a6a0d35dfe upstream.

Executing cmd 'rmmod rtl8150' does not return(if your device connects
to host), the root cause is tasklet_disable() causes tasklet_kill()
block, remove it from rtl8150_disconnect().

Signed-off-by: Huajun Li <huajun.li.lee@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/usb/rtl8150.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/usb/rtl8150.c
+++ b/drivers/net/usb/rtl8150.c
@@ -977,7 +977,6 @@ static void rtl8150_disconnect(struct us
 	usb_set_intfdata(intf, NULL);
 	if (dev) {
 		set_bit(RTL8150_UNPLUG, &dev->flags);
-		tasklet_disable(&dev->tl);
 		tasklet_kill(&dev->tl);
 		unregister_netdev(dev->netdev);
 		unlink_all_urbs(dev);


