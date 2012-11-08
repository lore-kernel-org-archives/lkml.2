Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab2KHLFV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 06:05:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47865 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508Ab2KHLFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 06:05:19 -0500
Date: Thu, 8 Nov 2012 12:05:13 +0100
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
Message-ID: <20121108110513.GE31821@dhcp22.suse.cz>
References: <1351771665-11076-1-git-send-email-glommer@parallels.com>
 <1351771665-11076-20-git-send-email-glommer@parallels.com>
 <20121105162837.5fdac20c.akpm@linux-foundation.org>
 <20121106080354.GA21167@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121106080354.GA21167@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 06-11-12 09:03:54, Michal Hocko wrote:
> On Mon 05-11-12 16:28:37, Andrew Morton wrote:
> > On Thu,  1 Nov 2012 16:07:35 +0400
> > Glauber Costa <glommer@parallels.com> wrote:
> > 
> > > +static __always_inline struct kmem_cache *
> > > +memcg_kmem_get_cache(struct kmem_cache *cachep, gfp_t gfp)
> > 
> > I still don't understand why this code uses __always_inline so much.
> 
> AFAIU, __always_inline (resp. __attribute__((always_inline))) is the
> same thing as inline if optimizations are enabled
> (http://ohse.de/uwe/articles/gcc-attributes.html#func-always_inline).

And this doesn't tell the whole story because there is -fearly-inlining
which enabled by default and it makes a difference when optimizations
are enabled so __always_inline really enforces inlining.

-- 
Michal Hocko
SUSE Labs
