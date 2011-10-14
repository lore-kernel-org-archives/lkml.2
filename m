Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747Ab1JNU2E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 16:28:04 -0400
Received: from smtp-out.google.com ([74.125.121.67]:8738 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950Ab1JNU2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 16:28:02 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=FzFYCiYZnhbWH5Z1IOPZ6xs7b5wx6Kt1t5CylqLAXNaGVzU0tb1FmbxKopU1NYqSf
	/nGDLXgii+beW0kVeNFpQ==
Date: Fri, 14 Oct 2011 13:27:55 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: tglx@linutronix.de, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
cc: H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Yinghai Lu <yinghai.lu@oracle.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] x86: use the same node_distance for 32 and 64-bit
In-Reply-To: <alpine.DEB.2.00.1109191748170.8943@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1110141325010.24783@chino.kir.corp.google.com>
References: <201109191603.15560.hartleys@visionengravers.com> <alpine.DEB.2.00.1109191748170.8943@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Sep 2011, David Rientjes wrote:

> On Mon, 19 Sep 2011, H Hartley Sweeten wrote:
> 
> > The node_distance function is not x86 64-bit specific.  Having the #ifdef
> > around the extern function declaration and the #define causes the default
> > node_distance macro to be used in asm-generic/topology.h. This also causes
> > a sparse warning in arch/x86/mm/numa.c when CONFIG_X86_64 is not set:
> > 
> > warning: symbol '__node_distance' was not declared. Should it be static?
> > 
> > Remove the #ifdef to fix both issues.
> > 
> > Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: Tejun Heo <tj@kernel.org>
> > Cc: Yinghai Lu <yinghai@kernel.org>
> 
>  [ I think kernel.org emails are still down, so I sent this to
>    htejun@gmail.com instead. ]
> 
> Acked-by: David Rientjes <rientjes@google.com>
> 

Ingo, Peter, I don't think this was merged into any x86 tree yet (and I 
gave up trying to figure it out, cloning from tesla.tglx.de was going 
about 2kB/sec).

It was also acked by Tejun Heo <tj@kernel.org> during review.

> > ---
> > diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
> > index c006924..800f77c 100644
> > --- a/arch/x86/include/asm/topology.h
> > +++ b/arch/x86/include/asm/topology.h
> > @@ -130,10 +130,8 @@ extern void setup_node_to_cpumask_map(void);
> >  	.balance_interval	= 1,					\
> >  }
> >  
> > -#ifdef CONFIG_X86_64
> >  extern int __node_distance(int, int);
> >  #define node_distance(a, b) __node_distance(a, b)
> > -#endif
> >  
> >  #else /* !CONFIG_NUMA */
> >  
