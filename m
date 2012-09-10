Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683Ab2IJIvw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 04:51:52 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:24804 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756300Ab2IJIvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 04:51:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqcCAHGoTVBbdWObgWdsb2JhbABFhUBHtUoiAQEWJieCIQEFIwQLAUYQJQImAgJXBhOIFKgVkjuBIY8WgRIDlV2TBQ
X-IronPort-AV: E=Sophos;i="4.80,397,1344204000"; 
   d="scan'208";a="949262510"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
Subject: [PATCH 15/20] Staging: ipack/devices/ipoctal: free the IRQ.
Date: Mon, 10 Sep 2012 10:51:53 +0200
Message-Id: <1347267118-9580-15-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347267118-9580-1-git-send-email-siglesias@igalia.com>
References: <1347267118-9580-1-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the IRQ was requested by the driver, it should free it also.

Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
---
 drivers/staging/ipack/devices/ipoctal.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/ipack/devices/ipoctal.c b/drivers/staging/ipack/devices/ipoctal.c
index 272832f..35513d9 100644
--- a/drivers/staging/ipack/devices/ipoctal.c
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@ -803,6 +803,8 @@ static void __ipoctal_remove(struct ipoctal *ipoctal)
 {
 	int i;
 
+	ipoctal->dev->bus->ops->free_irq(ipoctal->dev);
+
 	for (i = 0; i < NR_CHANNELS; i++) {
 		tty_unregister_device(ipoctal->tty_drv, i);
 		tty_port_free_xmit_buf(&ipoctal->tty_port[i]);
-- 
1.7.10.4

