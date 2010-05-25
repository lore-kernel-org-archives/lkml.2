Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759104Ab0EYV3p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 17:29:45 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56342 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756657Ab0EYV3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 17:29:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=kz28l12Ovw77DvdeKmxOTFZ4XKBUWwAfkUnErbZfpjZb5gFxCQfFjD6ZfMfO0pYcEg
         ShhIKMr/GSxn3ZmY55w1+pGTrn2fP8nShvcfW3UMKgJlk3z2x4ck2SHKX7i0ZlL8aMxm
         YF5MWoGJ2IWgtdsCQfAvZ3JHszz7ZfS+4+yng=
Date: Tue, 25 May 2010 23:29:13 +0200
From: Dan Carpenter <error27@gmail.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
       Henrik Kretzschmar <henne@nachtwindheim.de>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] padata: add parenthesis in MAX_SEQ_NR macro
Message-ID: <20100525212913.GK22515@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Henrik Kretzschmar <henne@nachtwindheim.de>,
	Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAX_SEQ_NR is used in padata_alloc_pd() like this:

        pd->max_seq_nr = (MAX_SEQ_NR / num_cpus) * num_cpus - 1;

It needs parenthesis or the divide by num_cpus takes precedence over the
subtraction.

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
Found by a static checker.  I don't really know this code.

diff --git a/kernel/padata.c b/kernel/padata.c
index b1c9857..ff8de1b 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -28,7 +28,7 @@
 #include <linux/slab.h>
 #include <linux/rcupdate.h>
 
-#define MAX_SEQ_NR INT_MAX - NR_CPUS
+#define MAX_SEQ_NR (INT_MAX - NR_CPUS)
 #define MAX_OBJ_NUM 1000
 
 static int padata_index_to_cpu(struct parallel_data *pd, int cpu_index)
