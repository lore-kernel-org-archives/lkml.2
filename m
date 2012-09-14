Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759834Ab2INSdX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 14:33:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40510 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759317Ab2INSdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 14:33:21 -0400
Date: Fri, 14 Sep 2012 11:33:16 -0700
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
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
Subject: Re: [RFC] cgroup TODOs
Message-ID: <20120914183316.GG17747@google.com>
References: <20120913205827.GO7677@google.com>
 <5052E7DF.7040000@parallels.com>
 <5052F4FF.6070508@huawei.com>
 <20120914175944.GF17747@google.com>
 <1347647021.7172.74.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347647021.7172.74.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Sep 14, 2012 at 08:23:41PM +0200, Peter Zijlstra wrote:
> Its hotplug, all hotplug stuff is synchronous, the last thing hotplug
> needs is the added complexity of async callbacks. Also pushing stuff out
> into worklets just to work around locking issues is vile.

I was asking whether it *has* to be part of synchronous CPU hotplug
operation.  IOW, do all tasks in the depleted cgroup have to be moved
to its parent before CPU hotunplug can proceed to completion or is it
okay to happen afterwards?  Making the migration part asynchronous
doesn't add much complexity.  The only thing you have to make sure is
flushing the previously scheduled one from the next CPU_UP_PREPARE.

Also note that this can't easily be solved by splitting tree
protecting inner lock from the outer lock.  We're talking about doing
full migration operations which likely require the outer one too.

> <handwave as I never can remember all the cgroup stuff/>
> 
> Can't we play games by pinning both cgroups with a reference and playing
> games with threadgroup_change / task_lock for the individual tasks being
> moved about?

I'm lost.  Can you please elaborate?

Thanks.

-- 
tejun
