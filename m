Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905Ab2IMMOw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 08:14:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36499 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756814Ab2IMMOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 08:14:48 -0400
Date: Thu, 13 Sep 2012 14:14:38 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, Peter Zijlstra <peterz@infradead.org>,
        Paul Turner <pjt@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Graf <tgraf@suug.ch>, "Serge E. Hallyn" <serue@us.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH REPOST RFC cgroup/for-3.7] cgroup: mark subsystems with
 broken hierarchy support and whine if cgroups are nested for them
Message-ID: <20120913121438.GC8055@dhcp22.suse.cz>
References: <20120910223125.GC7677@google.com>
 <20120910223355.GD7677@google.com>
 <20120911100433.GC8058@dhcp22.suse.cz>
 <5050568B.9090601@parallels.com>
 <20120912154907.GW21579@dhcp22.suse.cz>
 <20120912171120.GP7677@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120912171120.GP7677@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 12-09-12 10:11:20, Tejun Heo wrote:
> Hello,
> 
> On Wed, Sep 12, 2012 at 05:49:07PM +0200, Michal Hocko wrote:
> > > While I respect your goal of not warning about any configuration
> > > with max_level = 1, I believe the only sane configuration as soon
> > > as we get any 2nd-level child is use_hierarchy = 1 for everybody.
> > > 
> > > Everything aside from it should be warned.
> > 
> > Defintely. And that what the above guarantess, doesn't it?
> 
> I'm getting a bit worried that I might not be fully understanding what
> your concern is.  Can you please elaborate what your worries are and
> the transition plan that you have in your mind regarding
> .use_hierarchy?

I would like to see use_hierarchy go away. The only concern I have is 
to warn only if somebody is doing something wrong (aka flat
hierarchies). Or better put it this way. Do not warn in cases which do
not change if use_hierarchy is gone or default changes to 1.
An example:
root (use_hierarchy=0)
 | \
 |  A (use_hierarchy=0)
 |
 B (use_hierarachy=1)
 |\
 C D

is a perfectly sane configuration and I do not see any reason to fill
logs with some scary warnings when A is created. There will be no
semantical change in this setup When use_hierchy is gone.

So the only thing I am proposing here is to warn only if something
should be fixed in the configuration in order to be prepared for fully
hierarchical (and that is a second level of children from root with
use_hierachy==0).

Does it make more sense now?
-- 
Michal Hocko
SUSE Labs
