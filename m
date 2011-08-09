Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867Ab1HIC4c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 22:56:32 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35087 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201Ab1HIC4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 22:56:30 -0400
Date: Tue, 9 Aug 2011 12:56:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vinod Koul <vinod.koul@intel.com>
Subject: linux-next: manual merge of the moduleh tree with the slave-dma
 tree
Message-Id: <20110809125623.e25f685fd20c787fcf58fcfc@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Today's linux-next merge of the moduleh tree got a conflict in
include/linux/dmaengine.h between commit 90b44f8ffdf6 ("dmaengine: add
helper function for slave_single") from the slave-dma tree and commit
0719989d364d ("linux/dmaengine.h needs bitmap.h and asm/page.h") from the
moduleh tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.

Vinod, that slave-dma tree patch should probably remove the bare "struct
scallerlist;" since it now includes scatterlist,h.

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/dmaengine.h
index 0d738c9,1ceff5a..0000000
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@@ -24,7 -24,8 +24,9 @@@
  #include <linux/device.h>
  #include <linux/uio.h>
  #include <linux/dma-direction.h>
 +#include <linux/scatterlist.h>
+ #include <linux/bitmap.h>
+ #include <asm/page.h>
  
  struct scatterlist;
  
