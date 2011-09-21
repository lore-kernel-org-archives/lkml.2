Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581Ab1IUFEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 01:04:44 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:54629 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab1IUFEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 01:04:42 -0400
Date: Wed, 21 Sep 2011 15:04:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Becky Bruce <beckyb@kernel.crashing.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>
Subject: linux-next: manual merge of the moduleh tree with the powerpc tree
Message-Id: <20110921150439.9f776ec7ea3de37c642d419e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Today's linux-next merge of the moduleh tree got a conflict in
arch/powerpc/mm/tlb_nohash.c between commit 41151e77a4d9 ("powerpc:
Hugetlb for BookE") from the powerpc tree and commit 09773e3bc0e4
("powerpc: include export.h for files using EXPORT_SYMBOL/THIS_MODULE")
from the moduleh tree.

Just context changes. I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/powerpc/mm/tlb_nohash.c
index afc95c7,ab06aea..0000000
--- a/arch/powerpc/mm/tlb_nohash.c
+++ b/arch/powerpc/mm/tlb_nohash.c
@@@ -36,7 -36,7 +36,8 @@@
  #include <linux/spinlock.h>
  #include <linux/memblock.h>
  #include <linux/of_fdt.h>
 +#include <linux/hugetlb.h>
+ #include <linux/export.h>
  
  #include <asm/tlbflush.h>
  #include <asm/tlb.h>
