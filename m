Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab1AGCfT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 21:35:19 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:59255 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209Ab1AGCfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 21:35:17 -0500
Date: Fri, 7 Jan 2011 13:35:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>, Joe Perches <joe@perches.com>
Subject: linux-next: manual merge of the staging tree with the fbdev tree
Message-Id: <20110107133511.bcfc1e85.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/video/udlfb.c between commit realloc_framebuffer ("video: udlfb:
Kill off special printk wrappers, use pr_fmt()") from the fbdev tree and
commit 5b84cc781058bb452f869d84bb24442ec51948c4 ("staging: Use vzalloc")
from the staging tree.

Another commit in the fbdev tree moves this file out of staging (from
drivers/staging/udlfb/udlfb.c).

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/video/udlfb.c
index 020589a,8dd21e0..0000000
--- a/drivers/video/udlfb.c
+++ b/drivers/video/udlfb.c
@@@ -1128,9 -1163,9 +1128,9 @@@ static int dlfb_realloc_framebuffer(str
  		 * But with imperfect damage info we may send pixels over USB
  		 * that were, in fact, unchanged - wasting limited USB bandwidth
  		 */
- 		new_back = vmalloc(new_len);
+ 		new_back = vzalloc(new_len);
  		if (!new_back)
- 			pr_info("No shadow/backing buffer allcoated\n");
 -			dl_info("No shadow/backing buffer allocated\n");
++			pr_info("No shadow/backing buffer allocated\n");
  		else {
  			if (dev->backing_buffer)
  				vfree(dev->backing_buffer);
