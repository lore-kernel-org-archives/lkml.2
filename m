Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758861Ab0KQAG5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 19:06:57 -0500
Received: from mga14.intel.com ([143.182.124.37]:17762 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754502Ab0KQAG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 19:06:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,208,1288594800"; 
   d="scan'208";a="349668476"
Subject: Re: [patch 1/2] bootmem: add alloc_bootmem_align()
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: "hpa@zytor.com" <hpa@zytor.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.jf.intel.com>
In-Reply-To: <4CE30244.6090208@linux.intel.com>
References: <20101116212441.977574826@sbsiddha-MOBL3.sc.intel.com>
	 <4CE30244.6090208@linux.intel.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 16 Nov 2010 16:06:50 -0800
Message-Id: <1289952410.2683.38.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-16 at 14:14 -0800, H. Peter Anvin wrote:
> On 11/16/2010 01:23 PM, Suresh Siddha wrote:
> > Index: tree/include/linux/bootmem.h
> > ===================================================================
> > --- tree.orig/include/linux/bootmem.h
> > +++ tree/include/linux/bootmem.h
> > @@ -105,6 +105,8 @@ extern void *__alloc_bootmem_low_node(pg
> >  
> >  #define alloc_bootmem(x) \
> >  	__alloc_bootmem(x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
> > +#define alloc_bootmem_align(x, align) \
> > +	__alloc_bootmem(x, align, __pa(MAX_DMA_ADDRESS))
> >  #define alloc_bootmem_nopanic(x) \
> >  	__alloc_bootmem_nopanic(x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
> >  #define alloc_bootmem_pages(x) \
> 
>   [...]
> 
> >  	 */
> > -	init_xstate_buf = alloc_bootmem(xstate_size);
> > +	init_xstate_buf = alloc_bootmem_align(xstate_size,
> > +					      __alignof__(struct xsave_struct));
> >  	init_xstate_buf->i387.mxcsr = MXCSR_DEFAULT;
> 
> Perhaps it would make even more sense to have:
> 
> #define alloc_bootmem_alignof(x, type) \
> 	__alloc_bootmem(x, __alignof__(type), __pa(MAX_DMA_ADDRESS))
> 

Wanted to keep it broad so that more people can start using it.

For example, most of the current x86 uses of alloc_bootmem_pages() (or
the __alloc_bootmem() calls in other architectures) can be replaced with
alloc_bootmem_align() and most of them don't have a relevant type to
describe the alignment.

thanks,
suresh

