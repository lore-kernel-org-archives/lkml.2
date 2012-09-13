Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758688Ab2IMRSk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 13:18:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56126 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758650Ab2IMRSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 13:18:37 -0400
Date: Thu, 13 Sep 2012 10:18:32 -0700
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, Peter Zijlstra <peterz@infradead.org>,
        Paul Turner <pjt@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Graf <tgraf@suug.ch>, "Serge E. Hallyn" <serue@us.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH REPOST RFC cgroup/for-3.7] cgroup: mark subsystems with
 broken hierarchy support and whine if cgroups are nested for them
Message-ID: <20120913171832.GY7677@google.com>
References: <20120910223125.GC7677@google.com>
 <20120910223355.GD7677@google.com>
 <20120911100433.GC8058@dhcp22.suse.cz>
 <5050568B.9090601@parallels.com>
 <20120912154907.GW21579@dhcp22.suse.cz>
 <20120912171120.GP7677@google.com>
 <20120913121438.GC8055@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120913121438.GC8055@dhcp22.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Michal.

On Thu, Sep 13, 2012 at 02:14:38PM +0200, Michal Hocko wrote:
> I would like to see use_hierarchy go away. The only concern I have is 
> to warn only if somebody is doing something wrong (aka flat
> hierarchies). Or better put it this way. Do not warn in cases which do
> not change if use_hierarchy is gone or default changes to 1.
> An example:
> root (use_hierarchy=0)
>  | \
>  |  A (use_hierarchy=0)
>  |
>  B (use_hierarachy=1)
>  |\
>  C D
> 
> is a perfectly sane configuration and I do not see any reason to fill
> logs with some scary warnings when A is created. There will be no
> semantical change in this setup When use_hierchy is gone.
> 
> So the only thing I am proposing here is to warn only if something
> should be fixed in the configuration in order to be prepared for fully
> hierarchical (and that is a second level of children from root with
> use_hierachy==0).
> 
> Does it make more sense now?

Ah, okay, so what you're saying is that we shouldn't warn if 0
.use_hierarchys don't make any behavior difference from when they're
all 1, right?  If so, I have no objection.  Will incorporate your
updated version.

Thanks.

-- 
tejun
