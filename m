Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab2IRSKI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 14:10:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64731 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732Ab2IRSKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 14:10:05 -0400
Date: Tue, 18 Sep 2012 14:08:57 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, Michal Hocko <mhocko@suse.cz>,
        Glauber Costa <glommer@parallels.com>, Paul Turner <pjt@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Thomas Graf <tgraf@suug.ch>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>
Subject: Re: [RFC] cgroup TODOs
Message-ID: <20120918180857.GG16965@redhat.com>
References: <20120913205827.GO7677@google.com>
 <20120914142539.GC6221@redhat.com>
 <1347634409.7172.58.camel@twins>
 <20120914151447.GD6221@redhat.com>
 <20120914215701.GW17747@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120914215701.GW17747@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 02:57:01PM -0700, Tejun Heo wrote:

[..]
> I think we need to stick to one model for all controllers; otherwise,
> it gets confusing and unified hierarchy can't work.  That said, I'm
> not too happy about how cpu is handling it now.
> 
> * As I wrote before, the configuration esacpes cgroup proper and the
>   mapping from per-task value to group weight is essentially
>   arbitrary and may not exist depending on the resource type.
> 
> * The proportion of each group fluctuates as tasks fork and exit in
>   the parent group, which is confusing.
> 
> * cpu deals with tasks but blkcg deals with iocontexts and memcg,
>   which currently doesn't implement proportional control, deals with
>   address spaces (processes).  The proportions wouldn't even fluctuate
>   the same way across different controllers.
> 
> So, I really don't think the current model used by cpu is a good one
> and we rather should treat the tasks as a group competing with the
> rest of child groups.  Whether we can change that at this point, I
> don't know.  Peter, what do you think?

Peter, do you have thoughts on this? I vaguely remember that similar
discussion had happened for cpu controller. 

We first need to settle this debate of treating tasks at same level
as groups before further design points can be discussed.

Thanks
Vivek
