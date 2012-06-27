Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab2F0UYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 16:24:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58617 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587Ab2F0UYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 16:24:35 -0400
Date: Wed, 27 Jun 2012 13:24:30 -0700
From: Tejun Heo <tj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.cz>, Zhouping Liu <zliu@redhat.com>,
        linux-mm@kvack.org, Li Zefan <lizefan@huawei.com>,
        CAI Qian <caiqian@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: memcg: cat: memory.memsw.* : Operation not supported
Message-ID: <20120627202430.GS15811@google.com>
References: <2a1a74bf-fbb5-4a6e-b958-44fff8debff2@zmail13.collab.prod.int.phx2.redhat.com>
 <34bb8049-8007-496c-8ffb-11118c587124@zmail13.collab.prod.int.phx2.redhat.com>
 <20120627154827.GA4420@tiehlicka.suse.cz>
 <alpine.DEB.2.00.1206271256120.22162@chino.kir.corp.google.com>
 <20120627200926.GR15811@google.com>
 <alpine.DEB.2.00.1206271316070.22162@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1206271316070.22162@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jun 27, 2012 at 01:21:27PM -0700, David Rientjes wrote:
> Well it also has a prerequisite that memcg doesn't have: CONFIG_SWAP, so 

Right.

> even if CONFIG_CGROUP_MEM_RES_CTLR_SWAP is folded into 
> CONFIG_CGROUP_MEM_RES_CTLR, then these should still depend on CONFIG_SWAP 
> since configuring them would imply there is some limit to be enforced.
> 
> But to answer your question:
> 
>    text	   data	    bss	    dec	    hex	filename
>   25777	   3644	   4128	  33549	   830d	memcontrol.o.swap_disabled
>   27294	   4476	   4128	  35898	   8c3a	memcontrol.o.swap_enabled

I still wish it's folded into CONFIG_MEMCG and conditionalized just on
CONFIG_SWAP tho.

> Is it really too painful to not create these files when 
> CONFIG_CGROUP_MEM_RES_CTLR_SWAP is disabled?  If so, can we at least allow 
> them to be opened but return -EINVAL if memory.memsw.limit_in_bytes is 
> written?

Not at all, that was the first version anyway, which (IIRC) KAME
didn't like and suggested always creating those files.  KAME, what do
you think?

Thanks.

-- 
tejun
