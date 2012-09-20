Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab2ITBdc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 21:33:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58086 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab2ITBda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 21:33:30 -0400
Message-ID: <505A725B.2080901@amacapital.net>
Date: Wed, 19 Sep 2012 18:33:15 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.org>, Michal Hocko <mhocko@suse.cz>,
        Paul Mackerras <paulus@samba.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Johannes Weiner <hannes@cmpxchg.org>, Thomas Graf <tgraf@suug.ch>,
        Paul Turner <pjt@google.com>, Ingo Molnar <mingo@elte.hu>,
        serge.hallyn@canonical.com
Subject: Re: [RFC] cgroup TODOs
References: <20120913205827.GO7677@google.com>
In-Reply-To: <20120913205827.GO7677@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[grr.  why does gmane scramble addresses?]

On 09/13/2012 01:58 PM, Tejun Heo wrote:
> 
> 6. Multiple hierarchies
> 
>   Apart from the apparent wheeeeeeeeness of it (I think I talked about
>   that enough the last time[1]), there's a basic problem when more
>   than one controllers interact - it's impossible to define a resource
>   group when more than two controllers are involved because the
>   intersection of different controllers is only defined in terms of
>   tasks.
> 
>   IOW, if an entity X is of interest to two controllers, there's no
>   way to map X to the cgroups of the two controllers.  X may belong to
>   A and B when viewed by one task but A' and B when viewed by another.
>   This already is a head scratcher in writeback where blkcg and memcg
>   have to interact.
> 
>   While I am pushing for unified hierarchy, I think it's necessary to
>   have different levels of granularities depending on controllers
>   given that nesting involves significant overhead and noticeable
>   controller-dependent behavior changes.
> 
> 

> ...

>   I think this level of flexibility should be enough for most use
>   cases.  If someone disagrees, please voice your objections now.
> 

OK, I'll bite.

I have a server that has a whole bunch of cores.  A small fraction of
those cores are general purpose and run whatever they like.  The rest
are tightly controlled.

For simplicity, we have two cpusets that we use.  The root allows all
cpus.  The other one only allows the general purpose cpus.  We shove
everything into the general-purpose-only cpuset, and then we move
special stuff back to root.  (We also shove some kernel threads into a
non-root cpuset using the 'cset' tool.)

Enter systemd, which wants a hierarchy corresponding to services.  If we
were to use it, we might end up violating its hierarchy.

Alternatively, if we started using memcg, then we might have some tasks
to have more restrictive memory usage but less restrictive cpu usage.

As long as we can still pull this off, I'm happy.

--Andy

P.S.  I'm sure you can guess why based on my email address :)
