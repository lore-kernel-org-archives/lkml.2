Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab0D1GHt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 02:07:49 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56479 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752267Ab0D1GHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 02:07:47 -0400
Date: Wed, 28 Apr 2010 16:07:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Jason Wong <tsanghan@gmail.com>
Subject: linux-next: manual merge of the staging-next tree with the pcmcia
 tree
Message-Id: <20100428160741.2695a14f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the staging-next tree got a conflict in
drivers/staging/comedi/drivers/cb_das16_cs.c between commitc
8bf6e66c254bba7d0ea3f5d02420776dceac657 ("") from the pcmcia tree and
commit 6ea17dd43c1153f99920e66f806d86f4e83583cc ("Staging: comedi:
cb_das16_cs: fixed multiple brace coding style issues") from the
staging-next tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/comedi/drivers/cb_das16_cs.c
index e0352c6,68bd5ca..0000000
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@@ -175,17 -175,17 +175,17 @@@ static int das16cs_attach(struct comedi
  	printk("I/O base=0x%04lx ", dev->iobase);
  
  	printk("fingerprint:\n");
- 	for (i = 0; i < 48; i += 2) {
+ 	for (i = 0; i < 48; i += 2)
  		printk("%04x ", inw(dev->iobase + i));
- 	}
+ 
  	printk("\n");
  
 -	ret = request_irq(link->irq.AssignedIRQ, das16cs_interrupt,
 +	ret = request_irq(link->irq, das16cs_interrupt,
  			  IRQF_SHARED, "cb_das16_cs", dev);
- 	if (ret < 0) {
+ 	if (ret < 0)
  		return ret;
- 	}
+ 
 -	dev->irq = link->irq.AssignedIRQ;
 +	dev->irq = link->irq;
  	printk("irq=%u ", dev->irq);
  
  	dev->board_ptr = das16cs_probe(dev, link);
