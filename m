Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422902Ab2KNNbT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 08:31:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46866 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412Ab2KNNbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 08:31:18 -0500
Date: Wed, 14 Nov 2012 14:31:14 +0100
From: Michal Hocko <mhocko@suse.cz>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 1/4] mm, oom: ensure sysrq+f always passes valid zonelist
Message-ID: <20121114133114.GA4929@dhcp22.suse.cz>
References: <alpine.DEB.2.00.1211140111190.32125@chino.kir.corp.google.com>
 <20121114105049.GE17111@dhcp22.suse.cz>
 <alpine.DEB.2.00.1211140254020.6949@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1211140254020.6949@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 14-11-12 03:03:02, David Rientjes wrote:
> On Wed, 14 Nov 2012, Michal Hocko wrote:
> 
> > > With hotpluggable and memoryless nodes, it's possible that node 0 will
> > > not be online, so use the first online node's zonelist rather than
> > > hardcoding node 0 to pass a zonelist with all zones to the oom killer.
> > 
> > Makes sense although I haven't seen a machine with no 0 node yet.
> 
> We routinely do testing with them, actually, just by physically removing 
> all memory described by the SRAT that maps to node 0.  You could do the 
> same thing by making all pxms that map to node 0 to be hotpluggable in 
> your memory affinity structure.  I've been bit by it one too many times so 
> I always keep in mind that no single node id is guaranteed to be online 
> (although at least one node is always online); hence, first_online_node is 
> the solution.

I thought that a boot cpu would be bound to a node0 or something similar.
Thanks for the clarification!

> > According to 13808910 this is indeed possible.
> > 
> > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Signed-off-by: David Rientjes <rientjes@google.com>
> > 
> > Reviewed-by: Michal Hocko <mhocko@suse.cz>
> > 
> 
> Thanks!

-- 
Michal Hocko
SUSE Labs
