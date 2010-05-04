Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758589Ab0EDD5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 23:57:53 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60977 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756199Ab0EDD5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 23:57:51 -0400
Date: Tue, 4 May 2010 13:57:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Kilroy <kilroyd@googlemail.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: linux-next: manual merge of the pcmcia tree with the wireless tree
Message-Id: <20100504135748.10a7cf0e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dominik,

Today's linux-next merge of the pcmcia tree got conflicts in
drivers/net/wireless/orinoco/orinoco_cs.c and
drivers/net/wireless/orinoco/spectrum_cs.c between commit
593ef09c9e70c92c0d76c67a1c03a5d44d3aec82 ("orinoco: allow driver to
specify netdev_ops") from the wireless tree and commit
9632b5baa1f857a455a438e5510dc8bb507a85b0 ("pcmcia: re-work
pcmcia_request_irq()") from the pcmcia tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/wireless/orinoco/orinoco_cs.c
index f99b13b,03056ab..0000000
--- a/drivers/net/wireless/orinoco/orinoco_cs.c
+++ b/drivers/net/wireless/orinoco/orinoco_cs.c
@@@ -296,7 -281,7 +281,7 @@@ orinoco_cs_config(struct pcmcia_device 
  
  	/* Register an interface with the stack */
  	if (orinoco_if_add(priv, link->io.BasePort1,
- 			   link->irq.AssignedIRQ, NULL) != 0) {
 -			   link->irq) != 0) {
++			   link->irq, NULL) != 0) {
  		printk(KERN_ERR PFX "orinoco_if_add() failed\n");
  		goto failed;
  	}
diff --cc drivers/net/wireless/orinoco/spectrum_cs.c
index 9b1af49,41b9ce4..0000000
--- a/drivers/net/wireless/orinoco/spectrum_cs.c
+++ b/drivers/net/wireless/orinoco/spectrum_cs.c
@@@ -375,7 -359,7 +360,7 @@@ spectrum_cs_config(struct pcmcia_devic
  
  	/* Register an interface with the stack */
  	if (orinoco_if_add(priv, link->io.BasePort1,
- 			   link->irq.AssignedIRQ, NULL) != 0) {
 -			   link->irq) != 0) {
++			   link->irq, NULL) != 0) {
  		printk(KERN_ERR PFX "orinoco_if_add() failed\n");
  		goto failed;
  	}
