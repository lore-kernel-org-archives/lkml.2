Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927Ab2F0Psb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 11:48:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39396 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756740Ab2F0Psa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 11:48:30 -0400
Date: Wed, 27 Jun 2012 17:48:27 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Zhouping Liu <zliu@redhat.com>
Cc: linux-mm@kvack.org, Li Zefan <lizefan@huawei.com>,
        Tejun Heo <tj@kernel.org>, CAI Qian <caiqian@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: memcg: cat: memory.memsw.* : Operation not supported
Message-ID: <20120627154827.GA4420@tiehlicka.suse.cz>
References: <2a1a74bf-fbb5-4a6e-b958-44fff8debff2@zmail13.collab.prod.int.phx2.redhat.com>
 <34bb8049-8007-496c-8ffb-11118c587124@zmail13.collab.prod.int.phx2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34bb8049-8007-496c-8ffb-11118c587124@zmail13.collab.prod.int.phx2.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 26-06-12 23:49:15, Zhouping Liu wrote:
> hi, all
> 
> when I used memory cgroup in latest mainline, the following error occurred:
> 
> # mount -t cgroup -o memory xxx /cgroup/
> # ll /cgroup/memory.memsw.*
> -rw-r--r--. 1 root root 0 Jun 26 23:17 /cgroup/memory.memsw.failcnt
> -rw-r--r--. 1 root root 0 Jun 26 23:17 /cgroup/memory.memsw.limit_in_bytes
> -rw-r--r--. 1 root root 0 Jun 26 23:17 /cgroup/memory.memsw.max_usage_in_bytes
> -r--r--r--. 1 root root 0 Jun 26 23:17 /cgroup/memory.memsw.usage_in_bytes
> # cat /cgroup/memory.memsw.*
> cat: /cgroup/memory.memsw.failcnt: Operation not supported
> cat: /cgroup/memory.memsw.limit_in_bytes: Operation not supported
> cat: /cgroup/memory.memsw.max_usage_in_bytes: Operation not supported
> cat: /cgroup/memory.memsw.usage_in_bytes: Operation not supported
> 
> I'm confusing why it can't read memory.memsw.* files.

Those files are exported if CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y even
if the feature is turned off when any attempt to open the file returns
EOPNOTSUPP which is exactly what you are seeing.
This is a deliberate decision see: b6d9270d (memcg: always create memsw
files if CONFIG_CGROUP_MEM_RES_CTLR_SWAP).

Does this help to explain your problem? Do you actually see any problem
with this behavior?

Thanks
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
