Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030452Ab2CAB0L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 20:26:11 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:48282 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756388Ab2CAB0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 20:26:09 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of rientjes@google.com designates 10.68.228.41 as permitted sender) smtp.mail=rientjes@google.com; dkim=pass header.i=rientjes@google.com
Date: Wed, 29 Feb 2012 17:26:07 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Rafael Aquini <aquini@redhat.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Rik van Riel <riel@redhat.com>, Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] mm: SLAB Out-of-memory diagnostics
In-Reply-To: <20120229032715.GA23758@t510.redhat.com>
Message-ID: <alpine.DEB.2.00.1202291724100.17729@chino.kir.corp.google.com>
References: <20120229032715.GA23758@t510.redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Feb 2012, Rafael Aquini wrote:

> Following the example at mm/slub.c, add out-of-memory diagnostics to the SLAB
> allocator to help on debugging OOM conditions. This patch also adds a new
> sysctl, 'oom_dump_slabs_forced', that overrides the effect of __GFP_NOWARN page
> allocation flag and forces the kernel to report every slab allocation failure.
> 
> An example print out looks like this:
> 
>   <snip page allocator out-of-memory message>
>   SLAB: Unable to allocate memory on node 0 (gfp=0x11200)
>      cache: bio-0, object size: 192, order: 0
>      node0: slabs: 3/3, objs: 60/60, free: 0
> 
> Signed-off-by: Rafael Aquini <aquini@redhat.com>

I like it, except for the addition of the sysctl.  __GFP_NOWARN is used 
for a reason, usually because whatever is allocating memory can gracefully 
handle a failure and should not be emitted to the kernel log under any 
circumstances.
