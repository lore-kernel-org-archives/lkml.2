Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162Ab1GTOwI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 10:52:08 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:26722 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751418Ab1GTOwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 10:52:07 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 5jqn_gQVM1lVDwPo15_yEEJS50J_LXLPjQ7.MytYDxciw8Z
 v8BaOS7Wty.g5xl6t36WtcPTt.5POHJGrCzm3j7n4p0XYUrajW8ID3wHsXOC
 zcN8k4oEceZ9tE0sRqCHmjRZqZswh6xhW346mhoMLrGt71PUy2CsmdAtm0SQ
 tS06SzdqeD9HICs9UDMvaCpkokLHNylewKSIovcM6s3ngDUY0PKNCfs6E1SE
 vpku7gLld7uRhl8TEhIBB1wEC2IaSCRFyKKCOWRQmkLIgP.ifUcQbsndShDz
 E.1wB7ar7R2jzADKvzQ.9wkeltd8bMmnzSkBFalw_D2m25gt9YqBuOm8eAao
 4L6n5KNYccCXRqLQJEqDMMQxN
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 20 Jul 2011 09:52:03 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Mel Gorman <mgorman@suse.de>, Pekka Enberg <penberg@kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] mm-slab: allocate kmem_cache with __GFP_REPEAT
In-Reply-To: <1311170893.2338.29.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Message-ID: <alpine.DEB.2.00.1107200950270.1472@router.home>
References: <20110720121612.28888.38970.stgit@localhost6>  <alpine.DEB.2.00.1107201611010.3528@tiger> <20110720134342.GK5349@suse.de>  <alpine.DEB.2.00.1107200854390.32737@router.home> <1311170893.2338.29.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jul 2011, Eric Dumazet wrote:

> > Slab's kmem_cache is configured with an array of NR_CPUS which is the
> > maximum nr of cpus supported. Some distros support 4096 cpus in order to
> > accomodate SGI machines. That array then will have the size of 4096 * 8 =
> > 32k
>
> We currently support a dynamic schem for the possible nodes :
>
> cache_cache.buffer_size = offsetof(struct kmem_cache, nodelists) +
> 	nr_node_ids * sizeof(struct kmem_list3 *);
>
> We could have a similar trick to make the real size both depends on
> nr_node_ids and nr_cpu_ids.
>
> (struct kmem_cache)->array would become a pointer.

We should be making it a per cpu pointer like slub then. I looked at what
it would take to do so a couple of month ago but it was quite invasive.

The other solution is to use slub instead.

