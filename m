Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab0J3SVB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 14:21:01 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:29219 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062Ab0J3SU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 14:20:58 -0400
Date: Sat, 30 Oct 2010 20:10:41 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        Arnd Bergmann <arnd@arndb.de>, cbe-oss-dev@lists.ozlabs.org
Subject: [PATCH] PowerPC/Cell: use vzalloc rather than vmalloc and memset in
 spu_alloc_lscsa_std
Message-ID: <alpine.LNX.2.00.1010302004290.1572@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We can get rid of a memset in 
arch/powerpc/platforms/cell/spufs/lscsa_alloc.c::spu_alloc_lscsa_std() by 
using vzalloc() rather than vmalloc()+memset().

Completely untested patch below since I have no hardware nor tools to 
compile this.


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 lscsa_alloc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/cell/spufs/lscsa_alloc.c b/arch/powerpc/platforms/cell/spufs/lscsa_alloc.c
index a101abf..3b894f5 100644
--- a/arch/powerpc/platforms/cell/spufs/lscsa_alloc.c
+++ b/arch/powerpc/platforms/cell/spufs/lscsa_alloc.c
@@ -36,10 +36,9 @@ static int spu_alloc_lscsa_std(struct spu_state *csa)
 	struct spu_lscsa *lscsa;
 	unsigned char *p;
 
-	lscsa = vmalloc(sizeof(struct spu_lscsa));
+	lscsa = vzalloc(sizeof(struct spu_lscsa));
 	if (!lscsa)
 		return -ENOMEM;
-	memset(lscsa, 0, sizeof(struct spu_lscsa));
 	csa->lscsa = lscsa;
 
 	/* Set LS pages reserved to allow for user-space mapping. */


-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

