Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919Ab0LPFqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 00:46:25 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:33466 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab0LPFqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 00:46:22 -0500
Date: Thu, 16 Dec 2010 06:46:20 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Tejun Heo <htejun@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>
Subject: Re: [patch 2/3] add new macros to make percpu readmostly section
	correctly align
Message-ID: <20101216054620.GA3241@merkur.ravnborg.org>
References: <1291255347.12777.116.camel@sli10-conroe> <4D0243DD.3090507@gmail.com> <1292200886.2323.15.camel@sli10-conroe> <4D05EBA4.60202@gmail.com> <1292288924.2323.458.camel@sli10-conroe> <4D073FA9.9020801@gmail.com> <1292378268.2323.464.camel@sli10-conroe> <4D08CBF4.6040102@gmail.com> <1292460817.2323.465.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292460817.2323.465.camel@sli10-conroe>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 08:53:37AM +0800, Shaohua Li wrote:
> On Wed, 2010-12-15 at 22:08 +0800, Tejun Heo wrote:
> > Hello,
> > 
> > On 12/15/2010 02:57 AM, Shaohua Li wrote:
> > > How about this one?
> > 
> > Much better.  :-)
> > 
> > > +#ifdef INTERNODE_CACHE_BYTES
> > > +#define INTERNODE_CACHEALIGNED						\
> > > +	. = ALIGN(INTERNODE_CACHE_BYTES);
> > > +#else
> > > +#define INTERNODE_CACHEALIGNED
> > > +#endif
> > 
> > Yeah, this looks good.
> > 
> > > Index: linux/arch/x86/kernel/vmlinux.lds.S
> > > ===================================================================
> > > --- linux.orig/arch/x86/kernel/vmlinux.lds.S	2010-12-15 09:37:01.000000000 +0800
> > > +++ linux/arch/x86/kernel/vmlinux.lds.S	2010-12-15 09:37:06.000000000 +0800
> > > @@ -20,11 +20,11 @@
> > >  #define LOAD_OFFSET __START_KERNEL_map
> > >  #endif
> > >  
> > > -#include <asm-generic/vmlinux.lds.h>
> > >  #include <asm/asm-offsets.h>
> > >  #include <asm/thread_info.h>
> > >  #include <asm/page_types.h>
> > >  #include <asm/cache.h>
> > > +#include <asm-generic/vmlinux.lds.h>
> > >  #include <asm/boot.h>
> > 
> > Why do we need this chunk?
> the cache size is defined in cache.h, so I need move vmlinux.lds.h after
> cache.h

The right fix is to move the inclusion of cache.h to asm-generic/vmlinux.lds.h.
A quick audit only found sparc that failed to guard non assembler stuff.

	Sam
