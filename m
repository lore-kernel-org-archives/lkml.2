Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab2INLZR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 07:25:17 -0400
Received: from [205.233.59.134] ([205.233.59.134]:56880 "EHLO
	merlin.infradead.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab2INLZO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 07:25:14 -0400
Message-ID: <1347621740.7172.27.camel@twins>
Subject: Re: [RFC] cgroup TODOs
From: Peter Zijlstra <peterz@infradead.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Glauber Costa <glommer@parallels.com>, Tejun Heo <tj@kernel.org>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        Paul Turner <pjt@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Graf <tgraf@suug.ch>, "Serge E. Hallyn" <serue@us.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 14 Sep 2012 13:22:20 +0200
In-Reply-To: <5052F4FF.6070508@huawei.com>
References: <20120913205827.GO7677@google.com>
	 <5052E7DF.7040000@parallels.com> <5052F4FF.6070508@huawei.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-14 at 17:12 +0800, Li Zefan wrote:
> > I think this is a pressing problem, yes, but not the only problem with
> > cgroup lock. Even if we restrict its usage to cgroup core, we still can
> > call cgroup functions, which will lock. And then we gain nothing.
> > 
> 
> Agreed. The biggest issue in cpuset is if hotplug makes a cpuset's cpulist
> empty the tasks in it will be moved to an ancestor cgroup, which requires
> holding cgroup lock. We have to either change cpuset's behavior or eliminate
> the global lock. 

PJ (the original cpuset author) has always been very conservative in
changing cpuset semantics/behaviour. Its being used at the big HPC labs
and those people simply don't like change.

It also ties in with us having to preserve ABI, Linus says you can only
do so if nobody notices -- if a tree falls in a forest and there's
nobody to hear it, it really didn't fall at all.

Which I guess means we're going to have to split locks :-)
