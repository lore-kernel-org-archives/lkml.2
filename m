Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999Ab1IKBG1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 21:06:27 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:59176 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138Ab1IKBG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 21:06:26 -0400
Date: Sun, 11 Sep 2011 10:06:19 +0900
From: Tejun Heo <tj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        penberg@kernel.org, yinghai@kernel.org
Subject: Re: [PATCH] arch/x86/mm/numa.c: quiet sparse noise when
 CONFIG_X86_64 is not set
Message-ID: <20110911010619.GG29319@htj.dyndns.org>
References: <201109091638.49186.hartleys@visionengravers.com>
 <alpine.DEB.2.00.1109100238110.17756@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1109100238110.17756@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Sep 10, 2011 at 02:39:02AM -0700, David Rientjes wrote:
> On Fri, 9 Sep 2011, H Hartley Sweeten wrote:
> 
> > diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
> > index fbeaaf4..11c60a7 100644
> > --- a/arch/x86/mm/numa.c
> > +++ b/arch/x86/mm/numa.c
> > @@ -455,6 +455,7 @@ void __init numa_set_distance(int from, int to, int distance)
> >  	numa_distance[from * numa_distance_cnt + to] = distance;
> >  }
> >  
> > +#ifdef CONFIG_X86_64
> >  int __node_distance(int from, int to)
> >  {
> >  	if (from >= numa_distance_cnt || to >= numa_distance_cnt)
> > @@ -462,6 +463,7 @@ int __node_distance(int from, int to)
> >  	return numa_distance[from * numa_distance_cnt + to];
> >  }
> >  EXPORT_SYMBOL(__node_distance);
> > +#endif
> >  
> >  /*
> >   * Sanity check to catch more bad NUMA configurations (they are amazingly
> > 
> 
> What is 64-bit specific about this function?  Shouldn't we be defining it 
> to be node_distance for all of x86?

Yeap, that's a remnant of the old separate code paths, which wasn't
discovered because asm-generic/topology.h defines fallback
node_distance() automatically.  We should drop #ifdef from
arch/x86/include/asm/topology.h::node_distance().  Hartley, can you
please send a patch to do that?

Thanks.

-- 
tejun
