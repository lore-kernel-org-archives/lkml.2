Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162293Ab1FAIUG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:20:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:44515 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162405Ab1FAITx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:19:53 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:11:21 2011
Message-Id: <20110601081121.372401945@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:10:24 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [054/165] net: Change netdev_fix_features messages loglevel
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 825
Lines: 28


From: Michael S. Tsirkin <mst@redhat.com>

[ Upstream commit 604ae14ffb6d75d6eef4757859226b758d6bf9e3 ]

Cool, how about we make 'Features changed' debug as well?
This way userspace can't fill up the log just by tweaking tun features
with an ioctl.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/core/dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5258,7 +5258,7 @@ void netdev_update_features(struct net_d
 	if (dev->features == features)
 		return;
 
-	netdev_info(dev, "Features changed: 0x%08x -> 0x%08x\n",
+	netdev_dbg(dev, "Features changed: 0x%08x -> 0x%08x\n",
 		dev->features, features);
 
 	if (dev->netdev_ops->ndo_set_features)


