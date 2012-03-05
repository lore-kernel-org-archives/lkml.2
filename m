Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786Ab2CEKd5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 05:33:57 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:37225 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756418Ab2CEKdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 05:33:55 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of penberg@gmail.com designates 10.112.27.137 as permitted sender) smtp.mail=penberg@gmail.com; dkim=pass header.i=penberg@gmail.com
Date: Mon, 5 Mar 2012 12:33:49 +0200 (EET)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Rafael Aquini <aquini@redhat.com>
cc: David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>, Rik van Riel <riel@redhat.com>,
        Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] mm: SLAB Out-of-memory diagnostics
In-Reply-To: <20120302143323.GB1868@t510.redhat.com>
Message-ID: <alpine.LFD.2.02.1203051233440.1945@tux.localdomain>
References: <20120229032715.GA23758@t510.redhat.com> <alpine.DEB.2.00.1202291724100.17729@chino.kir.corp.google.com> <20120302143323.GB1868@t510.redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2012, Rafael Aquini wrote:

> On Wed, Feb 29, 2012 at 05:26:07PM -0800, David Rientjes wrote:
> > On Wed, 29 Feb 2012, Rafael Aquini wrote:
> > 
> > > Following the example at mm/slub.c, add out-of-memory diagnostics to the SLAB
> > > allocator to help on debugging OOM conditions. This patch also adds a new
> > > sysctl, 'oom_dump_slabs_forced', that overrides the effect of __GFP_NOWARN page
> > > allocation flag and forces the kernel to report every slab allocation failure.
> > > 
> > > An example print out looks like this:
> > > 
> > >   <snip page allocator out-of-memory message>
> > >   SLAB: Unable to allocate memory on node 0 (gfp=0x11200)
> > >      cache: bio-0, object size: 192, order: 0
> > >      node0: slabs: 3/3, objs: 60/60, free: 0
> > > 
> > > Signed-off-by: Rafael Aquini <aquini@redhat.com>
> > 
> > I like it, except for the addition of the sysctl.  __GFP_NOWARN is used 
> > for a reason, usually because whatever is allocating memory can gracefully 
> > handle a failure and should not be emitted to the kernel log under any 
> > circumstances.
> 
> Ok, I'll drop the sysctl part then. Pekka?

Yes, please.
