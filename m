Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab0GNJtI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 05:49:08 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:62880 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab0GNJtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 05:49:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=JLrJfdONmHc44k8XwGr1oSxGT5fX01LCNGBgQ+H0SrtkZNcfALxb2LDdo/H+2/YqsV
         OjRc3yjUe6Lw3VOFRyUy2woti60xsIkwLDEU+lmVBtHJm//QQTVuzj2HnwUQzb39bttu
         cNuOwJcx7R/WCtiECIabM1Z73x66QanZey58U=
Message-ID: <4C3D87FD.6030101@gmail.com>
Date: Wed, 14 Jul 2010 17:48:45 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>
Subject: [PATCH] net/nuc900: enable Mac driver clock
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixed a bug that Mac driver does not work,because I missed the clk enable.

I have ever tested the driver when I submitted previous Mac driver patch,
and it worked good, since my bootloader has enabled the clock in advance.

But when I try to use other bootloader where clock engine was disabled,the
Mac driver does not work, so I send this patch to fix this issue.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>

---
 drivers/net/arm/w90p910_ether.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/arm/w90p910_ether.c b/drivers/net/arm/w90p910_ether.c
index 2e85246..4545d5a 100644
--- a/drivers/net/arm/w90p910_ether.c
+++ b/drivers/net/arm/w90p910_ether.c
@@ -822,6 +822,9 @@ static int w90p910_ether_open(struct net_device *dev)
 	w90p910_set_global_maccmd(dev);
 	w90p910_enable_rx(dev, 1);

+	clk_enable(ether->rmiiclk);
+	clk_enable(ether->clk);
+
 	ether->rx_packets = 0x0;
 	ether->rx_bytes = 0x0;

-- 
1.6.3.3
