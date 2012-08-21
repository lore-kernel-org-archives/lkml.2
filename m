Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab2HUHyj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 03:54:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56559 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900Ab2HUHyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 03:54:35 -0400
Date: Tue, 21 Aug 2012 09:54:30 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
        devel@openvz.org, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        kamezawa.hiroyu@jp.fujitsu.com, Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v2 09/11] memcg: propagate kmem limiting information to
 children
Message-ID: <20120821075430.GA19797@dhcp22.suse.cz>
References: <1344517279-30646-1-git-send-email-glommer@parallels.com>
 <1344517279-30646-10-git-send-email-glommer@parallels.com>
 <20120817090005.GC18600@dhcp22.suse.cz>
 <502E0BC3.8090204@parallels.com>
 <20120817093504.GE18600@dhcp22.suse.cz>
 <502E17C4.7060204@parallels.com>
 <20120817103550.GF18600@dhcp22.suse.cz>
 <502E1E90.1080805@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <502E1E90.1080805@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 17-08-12 14:36:00, Glauber Costa wrote:
> On 08/17/2012 02:35 PM, Michal Hocko wrote:
> >> > But I never said that can't happen. I said (ok, I meant) the static
> >> > branches can't be disabled.
> > Ok, then I misunderstood that because the comment was there even before
> > static branches were introduced and it made sense to me. This is
> > inconsistent with what we do for user accounting because even if we set
> > limit to unlimitted we still account. Why should we differ here?
> 
> Well, we account even without a limit for user accounting. This is a
> fundamental difference, no ?

Yes, user memory accounting is either on or off all the time (switchable
at boot time). 
My understanding of kmem is that the feature is off by default because
it brings an overhead that is worth only special use cases. And that
sounds good to me. I do not see a good reason to have runtime switch
off. It makes the code more complicated for no good reason. E.g. how do
you handle charges you left behind? Say you charged some pages for
stack?

But maybe you have a good use case for that?
-- 
Michal Hocko
SUSE Labs
