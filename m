Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564Ab2GFPQm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 11:16:42 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:26712 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750906Ab2GFPQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 11:16:41 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: hscMIOAVM1la4VRyWHutoKin7jj2BM4v76pQd4jGLNWutzV
 YkWwTPkfexL7V1nGPKkNYArZ.x.NIYBoKDgbIw7PoUxKxJYYYFdJeOF47cCl
 Or4jsYO3HOjYeS3KsBKWH.Ry1ZZS1xeL5Mf_ZcgBaNP7PBcxfsPdb5Itfbuc
 MIiiwhNYQQ.okadcOeFNrsw2zjrfbUg6RXJy2orbxA9haM7LjcBmdyBwHdy7
 V.A5rOFvVecDRcsMAWpxBWDpRshYNgUPeZkh3FuSE3z0n5A0jcWsc4Bk7v4J
 sxhuxR4cEO4OC.qEF61X.WJJ4tf3XqUnapxgt5L1uKbGQ6Br6Egwefo09nno
 Oxt4DTGiX5CORd9RnxkPSm5fvYRYd7pVSD.acwrD74lBzgUS1ea8pmkJD.VI
 3IsWiEpZo_dmzcpw0f4L_YsaKB9mpyEpVEJba
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 6 Jul 2012 10:16:36 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Glauber Costa <glommer@parallels.com>
cc: linux-mm@kvack.org, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, cgroups@vger.kernel.org,
        devel@openvz.org, kamezawa.hiroyu@jp.fujitsu.com,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Suleiman Souhlal <suleiman@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v4 24/25] memcg/slub: shrink dead caches
In-Reply-To: <1340015298-14133-25-git-send-email-glommer@parallels.com>
Message-ID: <alpine.DEB.2.00.1207061015030.28648@router.home>
References: <1340015298-14133-1-git-send-email-glommer@parallels.com> <1340015298-14133-25-git-send-email-glommer@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2012, Glauber Costa wrote:

> In the slub allocator, when the last object of a page goes away, we
> don't necessarily free it - there is not necessarily a test for empty
> page in any slab_free path.

This is the same btw in SLAB which keeps objects in per cpu caches and
keeps empty slab pages on special queues.

> This patch marks all memcg caches as dead. kmem_cache_shrink is called
> for the ones who are not yet dead - this will force internal cache
> reorganization, and then all references to empty pages will be removed.

You need to call this also for slab to drain the caches and free the pages
on the empty list.

