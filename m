Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750943Ab0DIAlj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 20:41:39 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54113 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751Ab0DIAlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 20:41:37 -0400
Date: Fri, 9 Apr 2010 10:41:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       chavey <chavey@google.com>
Subject: linux-next: manual merge of the net tree with Linus' tree
Message-Id: <20100409104135.d6008487.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the net tree got a conflict in
net/core/ethtool.c between commit
5a0e3ad6af8660be21ca98a971cd00f331318c05 ("include cleanup: Update gfp.h
and slab.h includes to prepare for breaking implicit slab.h inclusion
from percpu.h") from Linus' tree and commit
97f8aefbbfb5aa5c9944e5fa8149f1fdaf71c7b6 ("net: fix ethtool coding style
errors and warnings") from the net tree.

Just context changes.  I fixed it up (see below) and can carry the fix
for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc net/core/ethtool.c
index 9d55c57,99e9f85..0000000
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@@ -18,8 -18,7 +18,8 @@@
  #include <linux/ethtool.h>
  #include <linux/netdevice.h>
  #include <linux/bitops.h>
+ #include <linux/uaccess.h>
 +#include <linux/slab.h>
- #include <asm/uaccess.h>
  
  /*
   * Some useful ethtool_ops methods that're device independent.
