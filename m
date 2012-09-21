Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604Ab2IUHQo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 03:16:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32992 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753374Ab2IUHQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 03:16:42 -0400
Date: Fri, 21 Sep 2012 09:16:32 +0200
From: Michal Hocko <mhocko@suse.cz>
To: David Rientjes <rientjes@google.com>
Cc: Tejun Heo <tj@kernel.org>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, Glauber Costa <glommer@parallels.com>,
        Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Thomas Graf <tgraf@suug.ch>,
        "Serge E. Hallyn" <serue@us.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>, Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH 2.6.32] memcg: warn on deeper hierarchies with
 use_hierarchy==0
Message-ID: <20120921071632.GA13473@dhcp22.suse.cz>
References: <20120913205827.GO7677@google.com>
 <20120914150306.GQ28039@dhcp22.suse.cz>
 <20120919140203.GA5398@dhcp22.suse.cz>
 <20120919140308.GB5398@dhcp22.suse.cz>
 <alpine.DEB.2.00.1209191237020.749@chino.kir.corp.google.com>
 <20120920132400.GC23872@dhcp22.suse.cz>
 <alpine.DEB.2.00.1209201531250.17455@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1209201531250.17455@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 20-09-12 15:33:23, David Rientjes wrote:
> On Thu, 20 Sep 2012, Michal Hocko wrote:
> 
> > Yes printk_once is an alternative but I really wanted to have this as
> > much visible as possible. People tend to react to stack traceces more
> > and this one will trigger only if somebody is either doing something
> > wrong or the configuration is the one we are looking for.
> > 
> 
> That's the complete opposite of what Linus has said he wants, he said very 
> specifically that he doesn't want WARN_ONCE() or WARN_ON_ONCE() for 
> deprecation of tunables.  If you want to have this merged, then please get 
> him to ack it.

This is not meant to be merged upstream. I do not think this is a stable
material and Linus tree will get the more generic cgroup based patch
instead. This is just for distributions so that they can help to find
usecases which would prevent use_hierachy removal
 
> > Comparing to oom_adj, that one was used much more often so the WARN_ONCE
> > was too verbose especially when you usually had to wait for an userspace
> > update which is not the case here.
> 
> How is WARN_ONCE() too verbose for oom_adj?  It's printed once!  

It prints much more than one line, right? When I said oom_adj was used
much more I meant more applications cared about the value (so the
prbability of the warning was quite high) not that the message would be
printed multiple times. And to be honest I didn't mind WARN_ONCE being
used for that.

> And how can you claim that userspace doesn't need to change if it's
> creating a hierarchy while use_hierarchy == 0?

It is code vs. configuration change. You have to wait for an update or
change and recompile in the first case while the second one can be done
directly.

-- 
Michal Hocko
SUSE Labs
