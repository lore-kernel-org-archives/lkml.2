Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978Ab1KCCAE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 22:00:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51030 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934002Ab1KCBjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:39:09 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:27:41 2011
Message-Id: <20111102222741.674363082@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:26:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Randy Dunlap <randy.dunlap@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [022/101] irda: fix smsc-ircc2 section mismatch warning
In-Reply-To: <20111102222755.GA10893@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Randy Dunlap <randy.dunlap@oracle.com>

commit f470e5ae34d68880a38aa79ee5c102ebc2a1aef6 upstream.

Fix section mismatch warning:

WARNING: drivers/net/irda/smsc-ircc2.o(.devinit.text+0x1a7): Section mismatch in reference from the function smsc_ircc_pnp_probe() to the function .init.text:smsc_ircc_open()

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/irda/smsc-ircc2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/irda/smsc-ircc2.c
+++ b/drivers/net/irda/smsc-ircc2.c
@@ -515,7 +515,7 @@ static const struct net_device_ops smsc_
  *    Try to open driver instance
  *
  */
-static int __init smsc_ircc_open(unsigned int fir_base, unsigned int sir_base, u8 dma, u8 irq)
+static int __devinit smsc_ircc_open(unsigned int fir_base, unsigned int sir_base, u8 dma, u8 irq)
 {
 	struct smsc_ircc_cb *self;
 	struct net_device *dev;


