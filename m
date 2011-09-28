Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405Ab1I1Wlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:41:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53947 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932309Ab1I1Wlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:41:42 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:34 2011
Message-Id: <20110928220134.703436286@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:00:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Randy Dunlap <randy.dunlap@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [089/244] irda: fix smsc-ircc2 section mismatch warning
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

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


