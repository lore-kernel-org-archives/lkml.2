Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab1DTURe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 16:17:34 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:53837 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756026Ab1DTURd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 16:17:33 -0400
Subject: [PATCH V3 8/8] Enable benet to support zerocopy
From: Shirley Ma <mashirle@us.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: mst@redhat.com, Eric Dumazet <eric.dumazet@gmail.com>,
        Avi Kivity <avi@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1303328216.19336.18.camel@localhost.localdomain>
References: <1303328216.19336.18.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Apr 2011 13:17:16 -0700
Message-ID: <1303330636.19336.61.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Shirley Ma <xma@us.ibm.com>
---

 drivers/net/benet/be_main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/benet/be_main.c b/drivers/net/benet/be_main.c
index 7cb5a11..d7b7254 100644
--- a/drivers/net/benet/be_main.c
+++ b/drivers/net/benet/be_main.c
@@ -2982,6 +2982,7 @@ static int __devinit be_probe(struct pci_dev *pdev,
 	status = dma_set_mask(&pdev->dev, DMA_BIT_MASK(64));
 	if (!status) {
 		netdev->features |= NETIF_F_HIGHDMA;
+		netdev->features |= NETIF_F_ZEROCOPY;
 	} else {
 		status = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
 		if (status) {


