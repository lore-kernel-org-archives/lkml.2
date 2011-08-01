Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab1HADYJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 23:24:09 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33511 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926Ab1HADYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 23:24:03 -0400
Date: Mon, 1 Aug 2011 13:23:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <jaxboe@fusionio.com>
Subject: linux-next: build warning after merge of the moduleh tree
Message-Id: <20110801132359.1de051cb8a4a2bdfdad7560c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

After merging the moduleh tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

block/bsg-lib.c:75:1: warning: data definition has no type or storage class
block/bsg-lib.c:75:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
block/bsg-lib.c:75:1: warning: parameter names (without types) in function declaration
block/bsg-lib.c:164:1: warning: data definition has no type or storage class
block/bsg-lib.c:164:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
block/bsg-lib.c:164:1: warning: parameter names (without types) in function declaration
block/bsg-lib.c:210:1: warning: data definition has no type or storage class
block/bsg-lib.c:210:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
block/bsg-lib.c:210:1: warning: parameter names (without types) in function declaration
block/bsg-lib.c:244:1: warning: data definition has no type or storage class
block/bsg-lib.c:244:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
block/bsg-lib.c:244:1: warning: parameter names (without types) in function declaration
block/bsg-lib.c:297:1: warning: data definition has no type or storage class
block/bsg-lib.c:297:1: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
block/bsg-lib.c:297:1: warning: parameter names (without types) in function declaration

This is an interaction with commit aa387cc89567 ("block: add bsg helper
library") from the block tree.  That file should have included module.h
but now would need export.h it seems (just uses EXPORTSYMBOL_GPL).

I applied the following as a merge fix patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 1 Aug 2011 13:21:39 +1000
Subject: [PATCH] block: bsg-lib.c needs export.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 block/bsg-lib.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/block/bsg-lib.c b/block/bsg-lib.c
index f8c0a61..b82c11b 100644
--- a/block/bsg-lib.c
+++ b/block/bsg-lib.c
@@ -23,6 +23,7 @@
 #include <linux/slab.h>
 #include <linux/blkdev.h>
 #include <linux/delay.h>
+#include <linux/export.h>
 #include <linux/scatterlist.h>
 #include <linux/bsg-lib.h>
 #include <scsi/scsi_cmnd.h>
-- 
1.7.5.4

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
