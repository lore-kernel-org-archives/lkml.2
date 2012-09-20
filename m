Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326Ab2ITWd2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 18:33:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36410 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756267Ab2ITWd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 18:33:26 -0400
Date: Thu, 20 Sep 2012 15:33:23 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: Tejun Heo <tj@kernel.org>, containers@lists.linux-foundation.org,
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
In-Reply-To: <20120920132400.GC23872@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.00.1209201531250.17455@chino.kir.corp.google.com>
References: <20120913205827.GO7677@google.com> <20120914150306.GQ28039@dhcp22.suse.cz> <20120919140203.GA5398@dhcp22.suse.cz> <20120919140308.GB5398@dhcp22.suse.cz> <alpine.DEB.2.00.1209191237020.749@chino.kir.corp.google.com>
 <20120920132400.GC23872@dhcp22.suse.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2012, Michal Hocko wrote:

> Yes printk_once is an alternative but I really wanted to have this as
> much visible as possible. People tend to react to stack traceces more
> and this one will trigger only if somebody is either doing something
> wrong or the configuration is the one we are looking for.
> 

That's the complete opposite of what Linus has said he wants, he said very 
specifically that he doesn't want WARN_ONCE() or WARN_ON_ONCE() for 
deprecation of tunables.  If you want to have this merged, then please get 
him to ack it.

> Comparing to oom_adj, that one was used much more often so the WARN_ONCE
> was too verbose especially when you usually had to wait for an userspace
> update which is not the case here.

How is WARN_ONCE() too verbose for oom_adj?  It's printed once!  And how 
can you claim that userspace doesn't need to change if it's creating a 
hierarchy while use_hierarchy == 0?
