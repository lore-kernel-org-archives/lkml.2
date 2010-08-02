Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab0HBD5u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 23:57:50 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37763 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480Ab0HBD5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 23:57:47 -0400
Date: Mon, 2 Aug 2010 13:57:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Prashant P. Shah" <pshah.mumbai@gmail.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>
Subject: linux-next: manual merge of the staging-next tree with the pcmcia
 tree
Message-Id: <20100802135746.b869dabc.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the staging-next tree got a conflict in
drivers/staging/wlags49_h2/wl_cs.c between commits
9b3efec734d2d79d82a6f5cef25a618d41a6b2c5 ("pcmcia: do not use io_req_t
after call to pcmcia_request_io()") and
cd8ae1e0a5d36406b518cea25446492f07ddddcf ("pcmcia: do not use io_req_t
when calling pcmcia_request_io()") from the pcmcia tree and commit
6d98be390ab55bb5f617d69aedf9bec27d039b3b ("Staging: wl_cs.c: converted
space to tabs in wl_cs.c") from the staging-next tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/wlags49_h2/wl_cs.c
index f15afd2,464b067..0000000
--- a/drivers/staging/wlags49_h2/wl_cs.c
+++ b/drivers/staging/wlags49_h2/wl_cs.c
@@@ -132,35 -133,36 +132,35 @@@ extern dbg_info_t *DbgInfo
   ******************************************************************************/
  static int wl_adapter_attach(struct pcmcia_device *link)
  {
-     struct net_device   *dev;
-     struct wl_private	*lp;
-     /*------------------------------------------------------------------------*/
- 
-     DBG_FUNC( "wl_adapter_attach" );
-     DBG_ENTER( DbgInfo );
- 
-     dev = wl_device_alloc();
-     if(dev == NULL) {
-         DBG_ERROR( DbgInfo, "wl_device_alloc returned NULL\n");
- 	return -ENOMEM;
-     }
- 
-     link->resource[0]->end      = HCF_NUM_IO_PORTS;
-     link->resource[0]->flags    = IO_DATA_PATH_WIDTH_16;
-     link->conf.Attributes   = CONF_ENABLE_IRQ;
-     link->conf.IntType      = INT_MEMORY_AND_IO;
-     link->conf.ConfigIndex  = 5;
-     link->conf.Present      = PRESENT_OPTION;
- 
-     link->priv = dev;
-     lp = wl_priv(dev);
-     lp->link = link;
- 
-     wl_adapter_insert(link);
- 
-     DBG_LEAVE( DbgInfo );
-     return 0;
- } // wl_adapter_attach
+ 	struct net_device   *dev;
+ 	struct wl_private   *lp;
+ 	/*--------------------------------------------------------------------*/
+ 
+ 	DBG_FUNC("wl_adapter_attach");
+ 	DBG_ENTER(DbgInfo);
+ 
+ 	dev = wl_device_alloc();
+ 	if (dev == NULL) {
+ 		DBG_ERROR(DbgInfo, "wl_device_alloc returned NULL\n");
+ 		return -ENOMEM;
+ 	}
+ 
 -	link->io.NumPorts1      = HCF_NUM_IO_PORTS;
 -	link->io.Attributes1    = IO_DATA_PATH_WIDTH_16;
 -	link->io.IOAddrLines    = 6;
++	link->resource[0]->end  = HCF_NUM_IO_PORTS;
++	link->resource[0]->flags = IO_DATA_PATH_WIDTH_16;
+ 	link->conf.Attributes   = CONF_ENABLE_IRQ;
+ 	link->conf.IntType      = INT_MEMORY_AND_IO;
+ 	link->conf.ConfigIndex  = 5;
+ 	link->conf.Present      = PRESENT_OPTION;
+ 
+ 	link->priv = dev;
+ 	lp = wl_priv(dev);
+ 	lp->link = link;
+ 
+ 	wl_adapter_insert(link);
+ 
+ 	DBG_LEAVE(DbgInfo);
+ 	return 0;
+ } /* wl_adapter_attach */
  /*============================================================================*/
  
  
@@@ -289,61 -290,59 +288,60 @@@ static int wl_adapter_resume(struct pcm
   *      N/A
   *
   ******************************************************************************/
- void wl_adapter_insert( struct pcmcia_device *link )
+ void wl_adapter_insert(struct pcmcia_device *link)
  {
-     struct net_device       *dev;
-     int i;
-     int                     ret;
-     /*------------------------------------------------------------------------*/
+ 	struct net_device *dev;
+ 	int i;
+ 	int ret;
+ 	/*--------------------------------------------------------------------*/
  
-     DBG_FUNC( "wl_adapter_insert" );
-     DBG_ENTER( DbgInfo );
-     DBG_PARAM( DbgInfo, "link", "0x%p", link );
+ 	DBG_FUNC("wl_adapter_insert");
+ 	DBG_ENTER(DbgInfo);
+ 	DBG_PARAM(DbgInfo, "link", "0x%p", link);
  
-     dev     = link->priv;
+ 	dev     = link->priv;
  
-     /* Do we need to allocate an interrupt? */
-     link->conf.Attributes |= CONF_ENABLE_IRQ;
-     link->io_lines = 6;
+ 	/* Do we need to allocate an interrupt? */
+ 	link->conf.Attributes |= CONF_ENABLE_IRQ;
++	link->io_lines = 6;
  
-     ret = pcmcia_request_io(link);
-     if (ret != 0)
-         goto failed;
 -	ret = pcmcia_request_io(link, &link->io);
++	ret = pcmcia_request_io(link);
+ 	if (ret != 0)
+ 		goto failed;
  
-     ret = pcmcia_request_irq(link, (void *) wl_isr);
-     if (ret != 0)
-         goto failed;
+ 	ret = pcmcia_request_irq(link, (void *) wl_isr);
+ 	if (ret != 0)
+ 		goto failed;
  
-     ret = pcmcia_request_configuration(link, &link->conf);
-     if (ret != 0)
-         goto failed;
+ 	ret = pcmcia_request_configuration(link, &link->conf);
+ 	if (ret != 0)
+ 		goto failed;
  
-     dev->irq        = link->irq;
-     dev->base_addr  = link->resource[0]->start;
+ 	dev->irq        = link->irq;
 -	dev->base_addr  = link->io.BasePort1;
++	dev->base_addr  = link->resource[0]->start;
  
-     SET_NETDEV_DEV(dev, &link->dev);
-     if (register_netdev(dev) != 0) {
- 	printk("%s: register_netdev() failed\n", MODULE_NAME);
- 	goto failed;
-     }
+ 	SET_NETDEV_DEV(dev, &link->dev);
+ 	if (register_netdev(dev) != 0) {
+ 		printk("%s: register_netdev() failed\n", MODULE_NAME);
+ 		goto failed;
+ 	}
  
-     register_wlags_sysfs(dev);
+ 	register_wlags_sysfs(dev);
  
-     printk(KERN_INFO "%s: Wireless, io_addr %#03lx, irq %d, ""mac_address ",
-                dev->name, dev->base_addr, dev->irq);
-     for( i = 0; i < ETH_ALEN; i++ ) {
-         printk("%02X%c", dev->dev_addr[i], ((i < (ETH_ALEN-1)) ? ':' : '\n'));
-     }
+ 	printk(KERN_INFO "%s: Wireless, io_addr %#03lx, irq %d, ""mac_address ",
+ 		dev->name, dev->base_addr, dev->irq);
+ 	for (i = 0; i < ETH_ALEN; i++)
+ 		printk("%02X%c", dev->dev_addr[i], ((i < (ETH_ALEN-1)) ? ':' : '\n'));
  
-     DBG_LEAVE( DbgInfo );
-     return;
+ 	DBG_LEAVE(DbgInfo);
+ 	return;
  
  failed:
-     wl_adapter_release( link );
+ 	wl_adapter_release(link);
  
-     DBG_LEAVE(DbgInfo);
-     return;
- } // wl_adapter_insert
+ 	DBG_LEAVE(DbgInfo);
+ 	return;
+ } /* wl_adapter_insert */
  /*============================================================================*/
  
  
