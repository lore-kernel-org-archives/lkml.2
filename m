Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760078Ab0JZQrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 12:47:53 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:55492 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754809Ab0JZQrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 12:47:52 -0400
Date: Tue, 26 Oct 2010 18:45:05 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/net: sgiseeq: fix return on error
Message-ID: <20101026184505.077246a2@absol.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we continue on error, we'd likely free the IRQ that we
didn't get, right?

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 drivers/net/sgiseeq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/sgiseeq.c b/drivers/net/sgiseeq.c
index 9265315..3a0cc63 100644
--- a/drivers/net/sgiseeq.c
+++ b/drivers/net/sgiseeq.c
@@ -531,7 +531,7 @@ static int sgiseeq_open(struct net_device *dev)
 
 	if (request_irq(irq, sgiseeq_interrupt, 0, sgiseeqstr, dev)) {
 		printk(KERN_ERR "Seeq8003: Can't get irq %d\n", dev->irq);
-		err = -EAGAIN;
+		return -EAGAIN;
 	}
 
 	err = init_seeq(dev, sp, sregs);
-- 
1.7.2.2
