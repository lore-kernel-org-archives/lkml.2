Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055Ab0ELGD5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 02:03:57 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57626 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679Ab0ELGDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 02:03:55 -0400
Date: Wed, 12 May 2010 16:03:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dominik Brodowski <linux@dominikbrodowski.net>
Subject: linux-next: manual merge of the staging-next tree with the pcmcia
 tree
Message-Id: <20100512160352.daa747f8.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the staging-next tree got a conflict in
drivers/staging/wlags49_h2/wl_cs.c between commit
c8df2d45846e374de8ff601b9ea0537becfe75ca ("pcmcia: re-work
pcmcia_request_irq()") from the pcmcia tree and commit  ("") from the
staging-next tree.

I fixed it up (see below) and can carry the fix as necessary.

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/wlags49_h2/wl_cs.c
index c9d99d8,7c33ead..0000000
--- a/drivers/staging/wlags49_h2/wl_cs.c
+++ b/drivers/staging/wlags49_h2/wl_cs.c
@@@ -314,15 -317,15 +314,15 @@@ void wl_adapter_insert( struct pcmcia_d
      /* Do we need to allocate an interrupt? */
      link->conf.Attributes |= CONF_ENABLE_IRQ;
  
-     CS_CHECK(RequestIO, pcmcia_request_io(link, &link->io));
-     CS_CHECK(RequestIRQ, pcmcia_request_irq(link, wl_isr));
-     CS_CHECK(RequestConfiguration, pcmcia_request_configuration(link, &link->conf));
+ //    CS_CHECK(RequestIO, pcmcia_request_io(link, &link->io));
 -//    CS_CHECK(RequestIRQ, pcmcia_request_irq(link, &link->irq));
++//    CS_CHECK(RequestIRQ, pcmcia_request_irq(link, wl_isr));
+ //    CS_CHECK(RequestConfiguration, pcmcia_request_configuration(link, &link->conf));
  
  
 -    dev->irq        = link->irq.AssignedIRQ;
 +    dev->irq        = link->irq;
      dev->base_addr  = link->io.BasePort1;
  
-     SET_NETDEV_DEV(dev, &handle_to_dev(link));
+     SET_NETDEV_DEV(dev, &link->dev);
      if (register_netdev(dev) != 0) {
  	printk("%s: register_netdev() failed\n", MODULE_NAME);
  	goto failed;
