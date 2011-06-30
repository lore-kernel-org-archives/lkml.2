Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052Ab1F3CKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 22:10:24 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55165 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757887Ab1F3CKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 22:10:16 -0400
Date: Thu, 30 Jun 2011 12:10:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Subject: linux-next: manual merge of the libata tree with the Linus' tree
Message-Id: <20110630121006.0c447f1a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

Today's linux-next merge of the libata tree got a conflict in
drivers/ata/libahci.c between commit 49743170556e ("ahci: change 'masking
port_map' printk to KERN_WARNING level") from the Linus' tree and commit
c4d21d680e91 ("ata: Convert dev_printk(KERN_<LEVEL> to dev_<level>(")
from the libata tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/ata/libahci.c
index 41223c7,d8ff9c4..0000000
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@@ -452,9 -455,9 +455,9 @@@ void ahci_save_initial_config(struct de
  	}
  
  	if (mask_port_map) {
- 		dev_printk(KERN_WARNING, dev, "masking port_map 0x%x -> 0x%x\n",
- 			   port_map,
- 			   port_map & mask_port_map);
 -		dev_err(dev, "masking port_map 0x%x -> 0x%x\n",
++		dev_warn(dev, "masking port_map 0x%x -> 0x%x\n",
+ 			port_map,
+ 			port_map & mask_port_map);
  		port_map &= mask_port_map;
  	}
  
