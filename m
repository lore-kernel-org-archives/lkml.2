Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab2FZJFv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 05:05:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35383 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919Ab2FZJFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 05:05:49 -0400
Date: Tue, 26 Jun 2012 02:05:47 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Glauber Costa <glommer@parallels.com>
cc: cgroups@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>,
        devel@openvz.org, kamezawa.hiroyu@jp.fujitsu.com,
        Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@redhat.com>
Subject: Re: [PATCH 11/11] protect architectures where THREAD_SIZE >= PAGE_SIZE
 against fork bombs
In-Reply-To: <4FE9765D.2050301@parallels.com>
Message-ID: <alpine.DEB.2.00.1206260203400.16020@chino.kir.corp.google.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <1340633728-12785-12-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1206252157000.30072@chino.kir.corp.google.com> <4FE96358.6080601@parallels.com>
 <alpine.DEB.2.00.1206260143450.16020@chino.kir.corp.google.com> <4FE9765D.2050301@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2012, Glauber Costa wrote:

> > Right, because I'm sure that __GFP_KMEMCG will be used in additional
> > places outside of this patchset and it will be a shame if we have to
> > always add #ifdef's.  I see no reason why we would care if __GFP_KMEMCG
> > was used when CONFIG_CGROUP_MEM_RES_CTLR_KMEM=n with the semantics that it
> > as in this patchset.  It's much cleaner by making it 0x0 when disabled.
> > 
> 
> What I can do, instead, is to WARN_ON conditionally to the config option in
> the page allocator, and make sure no one is actually passing the flag in that
> case.
> 

I don't think adding a conditional to the page allocator's fastpath when 
CONFIG_CGROUP_MEM_RES_CTLR_KMEM=n is appropriate.  I don't understand why 
this can't be 0x0 for such a configuration, __GFP_KMEM certainly means 
nothing when we don't have it enabled so how is this different at all from 
kmemcheck?
