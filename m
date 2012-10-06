Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab2JFCTb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 22:19:31 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:41896 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab2JFCT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 22:19:29 -0400
Date: Sat, 6 Oct 2012 11:19:24 +0900
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
Message-ID: <20121006021924.GB2601@localhost>
References: <50637298.2090904@parallels.com>
 <20120927120806.GA29104@dhcp22.suse.cz>
 <20120927143300.GA4251@mtj.dyndns.org>
 <20120927144307.GH3429@suse.de>
 <20120927145802.GC4251@mtj.dyndns.org>
 <50649B4C.8000208@parallels.com>
 <20120930082358.GG10383@mtj.dyndns.org>
 <50695817.2030201@parallels.com>
 <20121003225458.GE19248@localhost>
 <506D7922.1050108@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506D7922.1050108@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Glauber.

On Thu, Oct 04, 2012 at 03:55:14PM +0400, Glauber Costa wrote:
> I don't want to bloat unrelated kmem_cache structures, so I can't embed
> a memcg array in there: I would have to have a pointer to a memcg array
> that gets assigned at first use. But if we don't want to have a static
> number, as you and christoph already frowned upon heavily, we may have
> to do that memcg side as well.
> 
> The array gets bigger, though, because it pretty much has to be enough
> to accomodate all css_ids. Even now, they are more than the 400 I used
> in this patchset. Not allocating all of them at once will lead to more
> complication and pointer chasing in here.

I don't think it would require more pointer chasing.  At the simplest,
we can just compare the array size each time.  If you wanna be more
efficient, all arrays can be kept at the same size and resized when
the number of memcgs cross the current number.  The only runtime
overhead would be one pointer deref which I don't think can be avoided
regardless of the indexing direction.

Thanks.

-- 
tejun
