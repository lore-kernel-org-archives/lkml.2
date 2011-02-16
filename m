Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053Ab1BPBqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:46:10 -0500
Received: from kroah.org ([198.145.64.141]:38805 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756775Ab1BPATP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:19:15 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:29 2011
Message-Id: <20110216001429.775992328@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:11:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Denis Kirjanov <dkirjanov@kernel.org>
Subject: [047/272] staging: rt2860: Fix incorrect netif_stop_queue usage warning
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Denis Kirjanov <dkirjanov@kernel.org>

commit 9c33008412683eba91bce2dc4575f28c728b6bd1 upstream.

The TX queues are allocated inside register_netdev.
It doesn't make any sense to stop the queue before
allocation.

Signed-off-by: Denis Kirjanov <dkirjanov@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/rt2860/rt_main_dev.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/staging/rt2860/rt_main_dev.c
+++ b/drivers/staging/rt2860/rt_main_dev.c
@@ -483,8 +483,6 @@ struct net_device *RtmpPhyNetDevInit(str
 	net_dev->ml_priv = (void *)pAd;
 	pAd->net_dev = net_dev;
 
-	netif_stop_queue(net_dev);
-
 	return net_dev;
 
 }


