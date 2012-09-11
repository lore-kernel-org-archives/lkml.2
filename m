Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab2IKMlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 08:41:20 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:55051 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab2IKMlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 08:41:18 -0400
Message-ID: <504F30DB.60808@huawei.com>
Date: Tue, 11 Sep 2012 20:38:51 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <containers@lists.linux-foundation.org>,
        <cgroups@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Glauber Costa <glommer@parallels.com>,
        Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Thomas Graf <tgraf@suug.ch>,
        "Serge E. Hallyn" <serue@us.ibm.com>, Vivek Goyal <vgoyal@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH REPOST RFC cgroup/for-3.7] cgroup: mark subsystems with
 broken hierarchy support and whine if cgroups are nested for them
References: <20120910223125.GC7677@google.com> <20120910223355.GD7677@google.com>
In-Reply-To: <20120910223355.GD7677@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/9/11 6:33, Tejun Heo wrote:
> (forgot cc'ing containers / cgroups mailing lists and used the old
>  address for Li.  Reposting.  Sorry for the noise.)
> 
> Currently, cgroup hierarchy support is a mess.  cpu related subsystems
> behave correctly - configuration, accounting and control on a parent
> properly cover its children.  blkio and freezer completely ignore
> hierarchy and treat all cgroups as if they're directly under the root
> cgroup.  Others show yet different behaviors.
> 
> These differing interpretations of cgroup hierarchy make using cgroup
> confusing and it impossible to co-mount controllers into the same
> hierarchy and obtain sane behavior.
> 
> Eventually, we want full hierarchy support from all subsystems and
> probably a unified hierarchy.  Users using separate hierarchies
> expecting completely different behaviors depending on the mounted
> subsystem is deterimental to making any progress on this front.
> 
> This patch adds cgroup_subsys.broken_hierarchy and sets it to %true
> for controllers which are lacking in hierarchy support.  The goal of
> this patch is two-fold.
> 
> * Move users away from using hierarchy on currently non-hierarchical
>   subsystems, so that implementing proper hierarchy support on those
>   doesn't surprise them.
> 
> * Keep track of which controllers are broken how and nudge the
>   subsystems to implement proper hierarchy support.
> 
> For now, start with a single warning message.  We can whine louder
> later on.
> 
> (I tried to document what's broken and how it should be fixed.  If I
>  got something wrong, please let me know.)
> 

So isn't cpuset broken too? child cpuset's cpu mask isn't necessary a subset
of the parent's if the cpu_exclusive flag is not set.

