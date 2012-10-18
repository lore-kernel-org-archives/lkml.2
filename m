Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046Ab2JRJeH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 05:34:07 -0400
Received: from mx2.parallels.com ([64.131.90.16]:35687 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754993Ab2JRJeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 05:34:06 -0400
Message-ID: <507FCD02.106@parallels.com>
Date: Thu, 18 Oct 2012 13:33:54 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>, <cgroups@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>, Tejun Heo <tj@kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, <devel@openvz.org>,
        <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v5 11/14] memcg: allow a memcg with kmem charges to be
 destructed.
References: <1350382611-20579-1-git-send-email-glommer@parallels.com> <1350382611-20579-12-git-send-email-glommer@parallels.com> <20121017151235.1e5d6f21.akpm@linux-foundation.org>
In-Reply-To: <20121017151235.1e5d6f21.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2012 02:12 AM, Andrew Morton wrote:
> On Tue, 16 Oct 2012 14:16:48 +0400
> Glauber Costa <glommer@parallels.com> wrote:
> 
>> Because the ultimate goal of the kmem tracking in memcg is to track slab
>> pages as well,
> 
> It is?  For a major patchset such as this, it's pretty important to
> discuss such long-term plans in the top-level discussion.  Covering
> things such as expected complexity, expected performance hit, how these
> plans affected the current implementation, etc.
> 
> The main reason for this is that if the future plans appear to be of
> doubtful feasibility and the current implementation isn't sufficiently
> useful without the future stuff, we shouldn't merge the current
> implementation.  It's a big issue!
> 

Not really. I am not talking about plans when it comes to slab. The code
is there, and usually always posted to linux-mm a few days after I post
this series. It also lives in the kmemcg-slab branch in my git tree.

I am trying to logically split it in two to aid reviewers work. I may
have made a mistake by splitting it this way, but so far I think it was
the right decision: it allowed people to focus on a part of the work
first, instead of going all the way in a 30-patch patch series that
would be merged atomically.

I believe they should be merged separately, to allow us to find any
issues easier. But I also believe that this "separate" should ultimately
live in the same merge window.

Pekka, from the slab side, already stated that 3.8 would not be
unreasonable.

As for the perfomance hit, my latest benchmark, quoted in the opening
mail of this series already include results for both patchsets.

