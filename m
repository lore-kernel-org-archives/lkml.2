Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610Ab2F0UJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 16:09:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49433 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756761Ab2F0UJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 16:09:31 -0400
Date: Wed, 27 Jun 2012 13:09:26 -0700
From: Tejun Heo <tj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.cz>, Zhouping Liu <zliu@redhat.com>,
        linux-mm@kvack.org, Li Zefan <lizefan@huawei.com>,
        CAI Qian <caiqian@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: memcg: cat: memory.memsw.* : Operation not supported
Message-ID: <20120627200926.GR15811@google.com>
References: <2a1a74bf-fbb5-4a6e-b958-44fff8debff2@zmail13.collab.prod.int.phx2.redhat.com>
 <34bb8049-8007-496c-8ffb-11118c587124@zmail13.collab.prod.int.phx2.redhat.com>
 <20120627154827.GA4420@tiehlicka.suse.cz>
 <alpine.DEB.2.00.1206271256120.22162@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1206271256120.22162@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Michal, David.

On Wed, Jun 27, 2012 at 01:04:51PM -0700, David Rientjes wrote:
> I think it's a crappy solution and one that is undocumented in 
> Documentation/cgroups/memory.txt.  If you can only enable swap accounting 
> at boot either via .config or the command line then these files should 
> never be added for CONFIG_CGROUP_MEM_RES_CTLR_SWAP=n or when 
> do_swap_account is 0.  It's much easier to test if the feature is enabled 
> by checking for the presence of these files at the memcg mount point 
> rather than doing an open(2) and checking for -EOPNOTSUPP, which isn't 
> even a listed error code.  I don't care how much cleaner it makes the 
> internal memcg code.

Yeah, it's kinda ugly.  Taking a step back, do we really need be able
to configure out memsw?  How much vmlinux bloat or runtime overhead
are we talking about?  I don't think config options need to be this
granular.

Thanks.

-- 
tejun
