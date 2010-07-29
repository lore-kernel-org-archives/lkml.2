Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344Ab0G2DT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 23:19:58 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37517 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401Ab0G2DTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 23:19:55 -0400
Date: Thu, 29 Jul 2010 13:19:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the workqueues tree with the
 lost-spurious-irq tree
Message-Id: <20100729131953.e51a0242.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

Today's linux-next merge of the workqueues tree got a conflict in
include/linux/libata.h between commit
fa7cd37f808c487f722d7a2ce9c0923a323922df ("libata: use IRQ expecting")
from the lost-spurious-irq tree and commit
ad72cf9885c536e3adae03f8337557ac9dd1e4bb ("libata: take advantage of cmwq
and remove concurrency limitations") from the workqueues tree.

Just overlapping additions.  I fixed it up (see below) and can carry the
fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/libata.h
index 3f5f159,f010f18..0000000
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@@ -751,8 -751,7 +751,9 @@@ struct ata_port 
  	struct ata_host		*host;
  	struct device 		*dev;
  
 +	struct irq_expect	*irq_expect;	/* for irq expecting */
 +
+ 	struct mutex		scsi_scan_mutex;
  	struct delayed_work	hotplug_task;
  	struct work_struct	scsi_rescan_task;
  
