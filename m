Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055Ab2I1N27 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 09:28:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35882 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757895Ab2I1N25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 09:28:57 -0400
Date: Fri, 28 Sep 2012 14:28:39 +0100
From: Mel Gorman <mgorman@suse.de>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, devel@openvz.org,
        Tejun Heo <tj@kernel.org>, linux-mm@kvack.org,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 07/13] mm: Allocate kernel pages to the right memcg
Message-ID: <20120928132839.GG29125@suse.de>
References: <1347977050-29476-1-git-send-email-glommer@parallels.com>
 <1347977050-29476-8-git-send-email-glommer@parallels.com>
 <20120927135053.GF3429@suse.de>
 <50657153.8010101@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <50657153.8010101@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 01:43:47PM +0400, Glauber Costa wrote:
> On 09/27/2012 05:50 PM, Mel Gorman wrote:
> >> +void __free_accounted_pages(struct page *page, unsigned int order)
> >> > +{
> >> > +	memcg_kmem_uncharge_page(page, order);
> >> > +	__free_pages(page, order);
> >> > +}
> >> > +
> >> > +void free_accounted_pages(unsigned long addr, unsigned int order)
> >> > +{
> >> > +	if (addr != 0) {
> >> > +		VM_BUG_ON(!virt_addr_valid((void *)addr));
> > This is probably overkill. If it's invalid, the next line is likely to
> > blow up anyway. It's no biggie.
> > 
> 
> So this is here because it is in free_pages() as well. If it blows, at
> least we know precisely why (if debugging), and VM_BUG_ON() is only
> compiled in when CONFIG_DEBUG_VM.
> 

Ah, I see.

> But I'm fine with either.
> Should it stay or should it go ?
> 

It can stay. It makes sense that it look similar to free_pages() and as
you say, it makes debugging marginally easier.


-- 
Mel Gorman
SUSE Labs
