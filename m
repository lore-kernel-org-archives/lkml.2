Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115Ab3AIWFF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 17:05:05 -0500
Received: from mail.kernel.org ([198.145.19.201]:40900 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932641Ab3AIUg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:36:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alan Cox <alan@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 05/47] ne2000: add the right platform device
Date: Wed,  9 Jan 2013 12:35:00 -0800
Message-Id: <20130109201730.096625176@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201729.435233560@linuxfoundation.org>
References: <20130109201729.435233560@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Alan Cox <alan@linux.intel.com>

[ Upstream commit da9da01d9199b5bb15289d0859053c9aa3a34ac0 ]

Without this udev doesn't have a way to key the ne device to the platform
device.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ne.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ne.c
+++ b/drivers/net/ne.c
@@ -814,6 +814,7 @@ static int __init ne_drv_probe(struct pl
 		dev->irq = irq[this_dev];
 		dev->mem_end = bad[this_dev];
 	}
+	SET_NETDEV_DEV(dev, &pdev->dev);
 	err = do_ne_probe(dev);
 	if (err) {
 		free_netdev(dev);


