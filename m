Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751296Ab1GYGz4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 02:55:56 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52848 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab1GYGzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 02:55:50 -0400
Subject: Re: [GIT PULL] SLAB changes for v3.1-rc0
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: torvalds@linux-foundation.org, cl@linux-foundation.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
In-Reply-To: <alpine.DEB.2.00.1107221108190.2996@tiger>
References: <alpine.DEB.2.00.1107221108190.2996@tiger>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jul 2011 08:55:42 +0200
Message-ID: <1311576942.6669.20.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 22 juillet 2011 à 11:08 +0300, Pekka Enberg a écrit :
> Hi Linus,
> 
> Here's batch of slab/slub/slob changes accumulated over the past few months.
> The biggest changes are alignment unification from Christoph Lameter and SLUB
> debugging improvements from Ben Greear. Also notable is SLAB 'struct
> kmem_cache' shrinkage from Eric Dumazet that helps large SMP systems.
> 
> Please note that the SLUB lockless slowpath patches will be sent in a separate
> pull request.
> 
>                          Pekka

Hi Pekka

Could we also merge in 3.1 following "simple enough" patch ?

Thanks

[PATCH] slab: remove one NR_CPUS dependency

Reduce high order allocations in do_tune_cpucache() for some setups.
(NR_CPUS=4096 -> we need 64KB)

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Acked-by: Christoph Lameter <cl@linux.com>
CC: Pekka Enberg <penberg@kernel.org>
---
 mm/slab.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 1e523ed..b80282a 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3934,7 +3934,7 @@ fail:
 
 struct ccupdate_struct {
 	struct kmem_cache *cachep;
-	struct array_cache *new[NR_CPUS];
+	struct array_cache *new[0];
 };
 
 static void do_ccupdate_local(void *info)
@@ -3956,7 +3956,8 @@ static int do_tune_cpucache(struct kmem_cache *cachep, int limit,
 	struct ccupdate_struct *new;
 	int i;
 
-	new = kzalloc(sizeof(*new), gfp);
+	new = kzalloc(sizeof(*new) + nr_cpu_ids * sizeof(struct array_cache *),
+		      gfp);
 	if (!new)
 		return -ENOMEM;
 


