Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab0LaOrd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 09:47:33 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39452 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502Ab0LaOrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 09:47:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=c5/OYwzoY8Wdu351StGLeF2BMABgIPuWBW5mWURaXIRTNUdxmGhE4eUSntqQ5r4rfw
         zKR+ETYeIpPqGcanaRFYOUYcG9zgNF1bqC4MjHsDRnhuTleeq9S26bkKPCpiwhJdCe+J
         l39AZE8qhQoWEizNFjI5cIa9h4riWDq3DMqJM=
Message-ID: <4D1DECFC.8020701@gmail.com>
Date: Fri, 31 Dec 2010 15:47:24 +0100
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: davem@davemloft.net, netdev@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] net: eepro testing positive EBUSY return by request_irq()?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix -EBUSY test for request_irq().

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/net/eepro.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

I just found this in the code, no bug was observed. Is this patch needed? the test
for an -EBUSY return by request_irq() occurs much more frequently in kernel code.

diff --git a/drivers/net/eepro.c b/drivers/net/eepro.c
index 7c82631..47cfecb 100644
--- a/drivers/net/eepro.c
+++ b/drivers/net/eepro.c
@@ -920,7 +920,7 @@ static int	eepro_grab_irq(struct net_device *dev)
 
 		eepro_sw2bank0(ioaddr); /* Switch back to Bank 0 */
 
-		if (request_irq (*irqp, NULL, IRQF_SHARED, "bogus", dev) != EBUSY) {
+		if (request_irq (*irqp, NULL, IRQF_SHARED, "bogus", dev) != -EBUSY) {
 			unsigned long irq_mask;
 			/* Twinkle the interrupt, and check if it's seen */
 			irq_mask = probe_irq_on();
