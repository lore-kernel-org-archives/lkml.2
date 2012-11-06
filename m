Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab2KFIEI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 03:04:08 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36860 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667Ab2KFIEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 03:04:07 -0500
Date: Tue, 6 Nov 2012 09:03:54 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Glauber Costa <glommer@parallels.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>, JoonSoo Kim <js1304@gmail.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v6 19/29] memcg: infrastructure to match an allocation to
 the right cache
Message-ID: <20121106080354.GA21167@dhcp22.suse.cz>
References: <1351771665-11076-1-git-send-email-glommer@parallels.com>
 <1351771665-11076-20-git-send-email-glommer@parallels.com>
 <20121105162837.5fdac20c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121105162837.5fdac20c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 05-11-12 16:28:37, Andrew Morton wrote:
> On Thu,  1 Nov 2012 16:07:35 +0400
> Glauber Costa <glommer@parallels.com> wrote:
> 
> > +static __always_inline struct kmem_cache *
> > +memcg_kmem_get_cache(struct kmem_cache *cachep, gfp_t gfp)
> 
> I still don't understand why this code uses __always_inline so much.

AFAIU, __always_inline (resp. __attribute__((always_inline))) is the
same thing as inline if optimizations are enabled
(http://ohse.de/uwe/articles/gcc-attributes.html#func-always_inline).
Which is the case for the kernel. I was always wondering why we have
this __always_inline thingy.
It has been introduced back in 2004 by Andi but the commit log doesn't
say much:
"
[PATCH] gcc-3.5 fixes
    
Trivial gcc-3.5 build fixes.
"
Andi what was the original motivation for this attribute?
 
> I don't recall seeing the compiler producing out-of-line versions of
> "static inline" functions

and if it decides then __always_inline will not help, right?

-- 
Michal Hocko
SUSE Labs
