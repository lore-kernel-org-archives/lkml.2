Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab0LPAxm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 19:53:42 -0500
Received: from mga03.intel.com ([143.182.124.21]:3462 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213Ab0LPAxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 19:53:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,351,1288594800"; 
   d="scan'208";a="362342545"
Subject: Re: [patch 2/3] add new macros to make percpu readmostly section
 correctly align
From: Shaohua Li <shaohua.li@intel.com>
To: Tejun Heo <htejun@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "sam@ravnborg.org" <sam@ravnborg.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>
In-Reply-To: <4D08CBF4.6040102@gmail.com>
References: <1291255347.12777.116.camel@sli10-conroe>
	 <4D0243DD.3090507@gmail.com> <1292200886.2323.15.camel@sli10-conroe>
	 <4D05EBA4.60202@gmail.com> <1292288924.2323.458.camel@sli10-conroe>
	 <4D073FA9.9020801@gmail.com> <1292378268.2323.464.camel@sli10-conroe>
	 <4D08CBF4.6040102@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Dec 2010 08:53:37 +0800
Message-ID: <1292460817.2323.465.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-15 at 22:08 +0800, Tejun Heo wrote:
> Hello,
> 
> On 12/15/2010 02:57 AM, Shaohua Li wrote:
> > How about this one?
> 
> Much better.  :-)
> 
> > +#ifdef INTERNODE_CACHE_BYTES
> > +#define INTERNODE_CACHEALIGNED						\
> > +	. = ALIGN(INTERNODE_CACHE_BYTES);
> > +#else
> > +#define INTERNODE_CACHEALIGNED
> > +#endif
> 
> Yeah, this looks good.
> 
> > Index: linux/arch/x86/kernel/vmlinux.lds.S
> > ===================================================================
> > --- linux.orig/arch/x86/kernel/vmlinux.lds.S	2010-12-15 09:37:01.000000000 +0800
> > +++ linux/arch/x86/kernel/vmlinux.lds.S	2010-12-15 09:37:06.000000000 +0800
> > @@ -20,11 +20,11 @@
> >  #define LOAD_OFFSET __START_KERNEL_map
> >  #endif
> >  
> > -#include <asm-generic/vmlinux.lds.h>
> >  #include <asm/asm-offsets.h>
> >  #include <asm/thread_info.h>
> >  #include <asm/page_types.h>
> >  #include <asm/cache.h>
> > +#include <asm-generic/vmlinux.lds.h>
> >  #include <asm/boot.h>
> 
> Why do we need this chunk?
the cache size is defined in cache.h, so I need move vmlinux.lds.h after
cache.h

Thanks,
Shaohua

