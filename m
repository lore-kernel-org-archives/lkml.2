Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab0DGC5X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 22:57:23 -0400
Received: from gate.crashing.org ([63.228.1.57]:53645 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921Ab0DGC5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 22:57:16 -0400
Subject: Re: [PATCH][GIT PULL] powerpc/tracing: Move TRACE_SYSTEM out of
 #if protection
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: rostedt@goodmis.org
Cc: LKML <linux-kernel@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Hollis Blanchard <hollisb@us.ibm.com>, Jeremy Kerr <jk@ozlabs.org>,
       Christoph Hellwig <hch@lst.de>
In-Reply-To: <1270606195.19685.15615.camel@gandalf.stny.rr.com>
References: <1270606195.19685.15615.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Apr 2010 12:56:48 +1000
Message-ID: <1270609008.13812.118.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-06 at 22:09 -0400, Steven Rostedt wrote:
> Ben,
> 
> You can pull this or just use this patch, which ever you prefer.
> 
> Please pull the latest powerpc tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> powerpc

Ah good timing, I'm right in the middle of preparing my -next branch :-)

Thanks.

Cheers,
Ben.

> Steven Rostedt (1):
>       powerpc/tracing: Move TRACE_SYSTEM out of #if protection
> 
> ----
>  arch/powerpc/kvm/trace.h                     |   13 ++++++++-----
>  arch/powerpc/platforms/cell/spufs/sputrace.h |    7 ++++---
>  2 files changed, 12 insertions(+), 8 deletions(-)
> ---------------------------
> commit 2ce066a4ff9869681f8819c76f0c58af4333ec58
> Author: Steven Rostedt <srostedt@redhat.com>
> Date:   Tue Apr 6 22:04:21 2010 -0400
> 
>     powerpc/tracing: Move TRACE_SYSTEM out of #if protection
>     
>     As explained in:
>     
>     commit d0b6e04a4cd8360e3c9c419f7c30a3081a0c142a
>     tracing/events: Move TRACE_SYSTEM outside of include guard
>     
>     The TRACE_SYSTEM must be outside the #if include protection.
>     
>     Cc: Christoph Hellwig <hch@lst.de>
>     Cc: Jeremy Kerr <jk@ozlabs.org>
>     Cc: Hollis Blanchard <hollisb@us.ibm.com>
>     Cc: Marcelo Tosatti <mtosatti@redhat.com>
>     Cc: Avi Kivity <avi@redhat.com>
>     Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>     Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> diff --git a/arch/powerpc/kvm/trace.h b/arch/powerpc/kvm/trace.h
> index a8e8400..fcc6a6b 100644
> --- a/arch/powerpc/kvm/trace.h
> +++ b/arch/powerpc/kvm/trace.h
> @@ -1,13 +1,11 @@
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM kvm
> +
>  #if !defined(_TRACE_KVM_H) || defined(TRACE_HEADER_MULTI_READ)
>  #define _TRACE_KVM_H
>  
>  #include <linux/tracepoint.h>
>  
> -#undef TRACE_SYSTEM
> -#define TRACE_SYSTEM kvm
> -#define TRACE_INCLUDE_PATH .
> -#define TRACE_INCLUDE_FILE trace
> -
>  /*
>   * Tracepoint for guest mode entry.
>   */
> @@ -100,5 +98,10 @@ TRACE_EVENT(kvm_gtlb_write,
>  
>  #endif /* _TRACE_KVM_H */
>  
> +#undef TRACE_INCLUDE_PATH
> +#undef TRACE_INCLUDE_FILE
> +#define TRACE_INCLUDE_PATH .
> +#define TRACE_INCLUDE_FILE trace
> +
>  /* This part must be outside protection */
>  #include <trace/define_trace.h>
> diff --git a/arch/powerpc/platforms/cell/spufs/sputrace.h b/arch/powerpc/platforms/cell/spufs/sputrace.h
> index db2656a..12a469a 100644
> --- a/arch/powerpc/platforms/cell/spufs/sputrace.h
> +++ b/arch/powerpc/platforms/cell/spufs/sputrace.h
> @@ -1,11 +1,11 @@
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM spufs
> +
>  #if !defined(_TRACE_SPUFS_H) || defined(TRACE_HEADER_MULTI_READ)
>  #define _TRACE_SPUFS_H
>  
>  #include <linux/tracepoint.h>
>  
> -#undef TRACE_SYSTEM
> -#define TRACE_SYSTEM spufs
> -
>  TRACE_EVENT(spufs_context,
>  	TP_PROTO(struct spu_context *ctx, struct spu *spu, const char *name),
>  	TP_ARGS(ctx, spu, name),
> @@ -34,6 +34,7 @@ TRACE_EVENT(spufs_context,
>  #endif /* _TRACE_SPUFS_H */
>  
>  #undef TRACE_INCLUDE_PATH
> +#undef TRACE_INCLUDE_FILE
>  #define TRACE_INCLUDE_PATH .
>  #define TRACE_INCLUDE_FILE sputrace
>  #include <trace/define_trace.h>
> 


