Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286Ab2JCWzJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 18:55:09 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:54535 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111Ab2JCWzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 18:55:07 -0400
Date: Thu, 4 Oct 2012 07:54:58 +0900
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, devel@openvz.org, linux-mm@kvack.org,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 04/13] kmem accounting basic infrastructure
Message-ID: <20121003225458.GE19248@localhost>
References: <50635F46.7000700@parallels.com>
 <20120926201629.GB20342@google.com>
 <50637298.2090904@parallels.com>
 <20120927120806.GA29104@dhcp22.suse.cz>
 <20120927143300.GA4251@mtj.dyndns.org>
 <20120927144307.GH3429@suse.de>
 <20120927145802.GC4251@mtj.dyndns.org>
 <50649B4C.8000208@parallels.com>
 <20120930082358.GG10383@mtj.dyndns.org>
 <50695817.2030201@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50695817.2030201@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Glauber.

On Mon, Oct 01, 2012 at 12:45:11PM +0400, Glauber Costa wrote:
> > where kmemcg_slab_idx is updated from sched notifier (or maybe add and
> > use current->kmemcg_slab_idx?).  You would still need __GFP_* and
> > in_interrupt() tests but current->mm and PF_KTHREAD tests can be
> > rolled into index selection.
> 
> How big would this array be? there can be a lot more kmem_caches than
> there are memcgs. That is why it is done from memcg side.

The total number of memcgs are pretty limited due to the ID thing,
right?  And kmemcg is only applied to subset of caches.  I don't think
the array size would be a problem in terms of memory overhead, would
it?  If so, RCU synchronize and dynamically grow them?

Thanks.

-- 
tejun
