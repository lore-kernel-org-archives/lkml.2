Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900Ab0EQDWr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 23:22:47 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40095 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752806Ab0EQDWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 23:22:42 -0400
Date: Mon, 17 May 2010 13:22:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alexander Kurz <linux@blala.de>, David Woodhouse <dwmw2@infradead.org>
Subject: linux-next: manual merge of the pcmcia tree with the mtd tree
Message-Id: <20100517132239.5cb9eb5d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dominik,

Today's linux-next merge of the pcmcia tree got a conflict in
drivers/mtd/maps/pcmciamtd.c between commit
9bdde162ebcc0237e722e8c3d0d376e35188a98f ("pcmciamtd: coding style
cleanups") from the mtd tree and commit
317b6d63000b3cc48c43d582d76063500e531a6c ("pcmcia: dev_node removal
(write-only drivers)") from the pcmcia tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/mtd/maps/pcmciamtd.c
index c4aacbf,87b2b8f..0000000
--- a/drivers/mtd/maps/pcmciamtd.c
+++ b/drivers/mtd/maps/pcmciamtd.c
@@@ -656,12 -646,11 +655,10 @@@ static int pcmciamtd_config(struct pcmc
  		pcmciamtd_release(link);
  		return -ENODEV;
  	}
- 	snprintf(dev->node.dev_name, sizeof(dev->node.dev_name), "mtd%d", mtd->index);
 -	info("mtd%d: %s", mtd->index, mtd->name);
 +	dev_info(&dev->p_dev->dev, "mtd%d: %s\n", mtd->index, mtd->name);
- 	link->dev_node = &dev->node;
  	return 0;
  
 - failed:
 -	err("CS Error, exiting");
 +	dev_err(&dev->p_dev->dev, "CS Error, exiting\n");
  	pcmciamtd_release(link);
  	return -ENODEV;
  }
