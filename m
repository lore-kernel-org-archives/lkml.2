Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759103Ab2INSYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 14:24:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:41508 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab2INSYR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 14:24:17 -0400
Message-ID: <1347647021.7172.74.camel@twins>
Subject: Re: [RFC] cgroup TODOs
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Glauber Costa <glommer@parallels.com>,
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
Date: Fri, 14 Sep 2012 20:23:41 +0200
In-Reply-To: <20120914175944.GF17747@google.com>
References: <20120913205827.GO7677@google.com>
	 <5052E7DF.7040000@parallels.com> <5052F4FF.6070508@huawei.com>
	 <20120914175944.GF17747@google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-14 at 10:59 -0700, Tejun Heo wrote:
> Hello,
> 
> On Fri, Sep 14, 2012 at 05:12:31PM +0800, Li Zefan wrote:
> > Agreed. The biggest issue in cpuset is if hotplug makes a cpuset's cpulist
> > empty the tasks in it will be moved to an ancestor cgroup, which requires
> > holding cgroup lock. We have to either change cpuset's behavior or eliminate
> > the global lock.
> 
> Does that have to happen synchronously?  Can't we have a cgroup
> operation which asynchronously pushes all tasks in a cgroup to its
> parent from a work item?

Its hotplug, all hotplug stuff is synchronous, the last thing hotplug
needs is the added complexity of async callbacks. Also pushing stuff out
into worklets just to work around locking issues is vile.

<handwave as I never can remember all the cgroup stuff/>

Can't we play games by pinning both cgroups with a reference and playing
games with threadgroup_change / task_lock for the individual tasks being
moved about?


