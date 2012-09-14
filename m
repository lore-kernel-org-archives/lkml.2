Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab2INR7w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 13:59:52 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36303 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab2INR7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 13:59:50 -0400
Date: Fri, 14 Sep 2012 10:59:44 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Glauber Costa <glommer@parallels.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Thomas Graf <tgraf@suug.ch>,
        "Serge E. Hallyn" <serue@us.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [RFC] cgroup TODOs
Message-ID: <20120914175944.GF17747@google.com>
References: <20120913205827.GO7677@google.com>
 <5052E7DF.7040000@parallels.com>
 <5052F4FF.6070508@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5052F4FF.6070508@huawei.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Sep 14, 2012 at 05:12:31PM +0800, Li Zefan wrote:
> Agreed. The biggest issue in cpuset is if hotplug makes a cpuset's cpulist
> empty the tasks in it will be moved to an ancestor cgroup, which requires
> holding cgroup lock. We have to either change cpuset's behavior or eliminate
> the global lock.

Does that have to happen synchronously?  Can't we have a cgroup
operation which asynchronously pushes all tasks in a cgroup to its
parent from a work item?

Thanks.

-- 
tejun
