Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab2F1Sbv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 14:31:51 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46524 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab2F1Sbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 14:31:50 -0400
Date: Thu, 28 Jun 2012 11:31:45 -0700
From: Tejun Heo <tj@kernel.org>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>, Michal Hocko <mhocko@suse.cz>,
        Zhouping Liu <zliu@redhat.com>, linux-mm@kvack.org,
        Li Zefan <lizefan@huawei.com>, CAI Qian <caiqian@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: memcg: cat: memory.memsw.* : Operation not supported
Message-ID: <20120628183145.GE22641@google.com>
References: <2a1a74bf-fbb5-4a6e-b958-44fff8debff2@zmail13.collab.prod.int.phx2.redhat.com>
 <34bb8049-8007-496c-8ffb-11118c587124@zmail13.collab.prod.int.phx2.redhat.com>
 <20120627154827.GA4420@tiehlicka.suse.cz>
 <alpine.DEB.2.00.1206271256120.22162@chino.kir.corp.google.com>
 <20120627200926.GR15811@google.com>
 <alpine.DEB.2.00.1206271316070.22162@chino.kir.corp.google.com>
 <20120627202430.GS15811@google.com>
 <4FEBD7C0.7090906@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FEBD7C0.7090906@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, KAME.

On Thu, Jun 28, 2012 at 01:04:16PM +0900, Kamezawa Hiroyuki wrote:
> >I still wish it's folded into CONFIG_MEMCG and conditionalized just on
> >CONFIG_SWAP tho.
> >
> 
> In old days, memsw controller was not very stable. So, we devided the config.
> And, it makes size of memory for swap-device double (adds 2bytes per swapent.)
> That is the problem.

I see.  Do you think it's now reasonable to drop the separate config
option?  Having memcg enabled but swap unaccounted sounds half-broken
to me.

> IIRC...at that time, we made decision, cgroup has no feature to
> 'create files dynamically'. Then, we made it in static, decision was done
> at compile time and ignores "do_swap_account".
> 
> Now, IIUC, we have the feature. So, it's may be a time to create the file
> with regard to "do_swap_account", making decision at boot time.

Heh, yeah, maybe I'm confused about how it happened.  Anyways, let's
get it fixed.

Thanks!

-- 
tejun
