Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab0GZI0Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 04:26:25 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:50806 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112Ab0GZI0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 04:26:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=LgWO93Xq+fHGh5gJtC2lGBYdJGbV8EfcFz+KPqWLuofMNllf1pRTkZ/0QOJ7hs2+Ls
         PJdanblS4TKnfKUWMRXk3UJXbxoWYMEJBhLaPPKCeo4L4L/smGtAtbGlnduqX9LdVwHl
         6ZCEjzy7hNoMY2NOYUWAq+4B3Kszqznpx0Z3s=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben@decadent.org.uk>, Joe Perches <joe@perches.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Jussi Kivilinna <jussi.kivilinna@mbnet.fi>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usbnet: use jiffies in schedule_timeout(), not msecs
Date: Mon, 26 Jul 2010 12:25:42 +0400
Message-Id: <1280132742-8126-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usbnet_terminate_urbs() uses schedule_timeout() with argument 3 msecs.
schedule_timeout() uses jiffies as argument, so convert msecs to jiffies
with msecs_to_jiffies().

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/net/usb/usbnet.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 7eab407..b243386 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -624,7 +624,7 @@ static void usbnet_terminate_urbs(struct usbnet *dev)
 	while (!skb_queue_empty(&dev->rxq)
 		&& !skb_queue_empty(&dev->txq)
 		&& !skb_queue_empty(&dev->done)) {
-			schedule_timeout(UNLINK_TIMEOUT_MS);
+			schedule_timeout(msecs_to_jiffies(UNLINK_TIMEOUT_MS));
 			set_current_state(TASK_UNINTERRUPTIBLE);
 			netif_dbg(dev, ifdown, dev->net,
 				  "waited for %d urb completions\n", temp);
-- 
1.7.0.4

