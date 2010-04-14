Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488Ab0DNBtA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 21:49:00 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57102 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753736Ab0DNBs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 21:48:59 -0400
Date: Wed, 14 Apr 2010 11:48:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Uri Simchoni <uri@jdland.co.il>
Subject: linux-next: manual merge of the crypto tree with Linus' tree
Message-Id: <20100414114856.54e1cb21.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Herbert,

Today's linux-next merge of the crypto tree got a conflict in
drivers/crypto/mv_cesa.c between commit
5a0e3ad6af8660be21ca98a971cd00f331318c05 ("include cleanup: Update gfp.h
and slab.h includes to prepare for breaking implicit slab.h inclusion
from percpu.h") from Linus' tree and commit
750052dd2400cd09e0864d75b63c2c0bf605056f ("crypto: mv_cesa - Add sha1 and
hmac(sha1) async hash drivers") from the crypto tree.

Just context changes.  I fixed it up (see below) and can carry the fix
for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/crypto/mv_cesa.c
index 6f29012,1cee5a9..0000000
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@@ -14,9 -14,14 +14,15 @@@
  #include <linux/kthread.h>
  #include <linux/platform_device.h>
  #include <linux/scatterlist.h>
 +#include <linux/slab.h>
+ #include <crypto/internal/hash.h>
+ #include <crypto/sha.h>
  
  #include "mv_cesa.h"
+ 
+ #define MV_CESA	"MV-CESA:"
+ #define MAX_HW_HASH_SIZE	0xFFFF
+ 
  /*
   * STM:
   *   /---------------------------------------\
