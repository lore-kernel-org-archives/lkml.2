Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274Ab0FQHyU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 03:54:20 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:58009 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756824Ab0FQHyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 03:54:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=XkWzaBUe5nSqTPpSQhDG7uyZU3dwWXzp774XfF4AmgVeIUjSfFMHani6wD2CbHw2rd
         pwilL6XzXtZi5MyjGXulfbzcBOk61xfgQlx0FvT4Ko5kNg8HgUqMKTfeocy6phSaDXh0
         ZqxiQvt6yS0lBuWHvm+DytEyYtZgRZCatgsPk=
Date: Thu, 17 Jun 2010 23:54:20 +0800
From: wzt.wzt@gmail.com
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, cl@linux-foundation.org, penberg@cs.helsinki.fi,
       mpm@selenic.com
Subject: [PATCH] Slabinfo: Fix display format
Message-ID: <20100617155420.GB2693@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix slabinfo display format, if a structure length > 17, the information display like:

[root@localhost ~]# cat /proc/slabinfo
flow_cache             0      0     80   48    1 : tunables  120   60    8 : slabdata      0      0      0
cfq_io_context        40    112     68   56    1 : tunables  120   60    8 : slabdata      2      2      0
cfq_queue             30     52    152   26    1 : tunables  120   60    8 : slabdata      2      2      0
bsg_cmd                0      0    284   14    1 : tunables   54   27    8 : slabdata      0      0      0
mqueue_inode_cache      1      7    576    7    1 : tunables   54   27    8 : slabdata      1      1      0
isofs_inode_cache      0      0    380   10    1 : tunables   54   27    8 : slabdata      0      0      0
hugetlbfs_inode_cache      1     11    352   11    1 : tunables   54   27    8 : slabdata      1      1      0
ext2_inode_cache       0      0    496    8    1 : tunables   54   27    8 : slabdata      0      0      0
ext2_xattr             0      0     48   78    1 : tunables  120   60    8 : slabdata      0      0      0
dquot                  0      0    192   20    1 : tunables  120   60    8 : slabdata      0      0      0
kioctx                 0      0    192   20    1 : tunables  120   60    8 : slabdata      0      0      0
kiocb                  0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

---
 mm/slab.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index e49f8f4..3bcba98 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -4181,7 +4181,7 @@ static void print_slabinfo_header(struct seq_file *m)
 #else
 	seq_puts(m, "slabinfo - version: 2.1\n");
 #endif
-	seq_puts(m, "# name            <active_objs> <num_objs> <objsize> "
+	seq_puts(m, "# name\t\t\t<active_objs> <num_objs> <objsize> "
 		 "<objperslab> <pagesperslab>");
 	seq_puts(m, " : tunables <limit> <batchcount> <sharedfactor>");
 	seq_puts(m, " : slabdata <active_slabs> <num_slabs> <sharedavail>");
@@ -4271,7 +4271,7 @@ static int s_show(struct seq_file *m, void *p)
 	if (error)
 		printk(KERN_ERR "slab: cache %s error: %s\n", name, error);
 
-	seq_printf(m, "%-17s %6lu %6lu %6u %4u %4d",
+	seq_printf(m, "%-27s %6lu %6lu %6u %4u %4d",
 		   name, active_objs, num_objs, cachep->buffer_size,
 		   cachep->num, (1 << cachep->gfporder));
 	seq_printf(m, " : tunables %4u %4u %4u",
-- 
1.6.5.3

