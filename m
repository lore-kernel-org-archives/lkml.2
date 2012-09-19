Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261Ab2ISTi0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 15:38:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43499 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab2ISTiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 15:38:21 -0400
Date: Wed, 19 Sep 2012 12:38:18 -0700 (PDT)
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
In-Reply-To: <20120919140308.GB5398@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.00.1209191237020.749@chino.kir.corp.google.com>
References: <20120913205827.GO7677@google.com> <20120914150306.GQ28039@dhcp22.suse.cz> <20120919140203.GA5398@dhcp22.suse.cz> <20120919140308.GB5398@dhcp22.suse.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2012, Michal Hocko wrote:

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index f99f599..b61c34b 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3106,6 +3106,11 @@ mem_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
>  	} else {
>  		parent = mem_cgroup_from_cont(cont->parent);
>  		mem->use_hierarchy = parent->use_hierarchy;
> +		WARN_ONCE(!mem->use_hierarchy && parent != root_mem_cgroup,
> +				"Creating hierarchies with use_hierarchy==0 "
> +				"(flat hierarchy) is considered deprecated. "
> +				"If you believe that your setup is correct, "
> +				"we kindly ask you to contact linux-mm@kvack.org and let us know");

When I deprecated /proc/pid/oom_adj (now removed), we did a WARN_ONCE() 
and others complained that this unnecessarily alters userspace scripts 
that a serious issue has occurred and Linus agreed that we shouldn't do 
deprecation in this way.  The alternative is to use printk_once() instead.

This applies to all three patches for this one, 3.0, and 3.2+.
