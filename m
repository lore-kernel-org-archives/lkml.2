Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732Ab0CXSNx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 14:13:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33343 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932415Ab0CXSNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 14:13:50 -0400
X-Authority-Analysis: v=1.1 cv=wckZLekju2+u3kt9osT+oU4XGSlOYx61urhSnO42l8s= c=1 sm=0 a=9yaGdwAZuD0A:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=20KFwNOVAAAA:8 a=XTT4vP6zRjBSgeJGPSwA:9 a=ITl8n4pSvtiEPDUJD7gA:7 a=qI_ExTxiRpJZio1XbegVVYTX2_sA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 2/2] rt: Remove CONFIG_STACK_TRACER from DEBUG_COUNT
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: John Kacur <jkacur@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Clark Williams <williams@redhat.com>
In-Reply-To: <1269452107-28655-3-git-send-email-jkacur@redhat.com>
References: <1269452107-28655-1-git-send-email-jkacur@redhat.com>
	 <1269452107-28655-3-git-send-email-jkacur@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 24 Mar 2010 14:13:48 -0400
Message-ID: <1269454428.2957.2890.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-24 at 18:35 +0100, John Kacur wrote:
> Remove CONFIG_STACK_TRACER from DEBUG_COUNT so that reminder messages
> are printed correctly, and don't leave an empty reminder block for example.
> 

I think this should be attached to patch 1. Why have two patches for
this?

-- Steve

> Signed-off-by: John Kacur <jkacur@redhat.com>
> ---
>  init/main.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/init/main.c b/init/main.c
> index aa48b7b..17fd973 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -908,7 +908,7 @@ static int __init kernel_init(void * unused)
>  	WARN_ON(irqs_disabled());
>  #endif
>  
> -#define DEBUG_COUNT (defined(CONFIG_DEBUG_RT_MUTEXES) + defined(CONFIG_IRQSOFF_TRACER) + defined(CONFIG_PREEMPT_TRACER) + defined(CONFIG_STACK_TRACER) + defined(CONFIG_INTERRUPT_OFF_HIST) + defined(CONFIG_PREEMPT_OFF_HIST) + defined(CONFIG_WAKEUP_LATENCY_HIST) + defined(CONFIG_DEBUG_SLAB) + defined(CONFIG_DEBUG_PAGEALLOC) + defined(CONFIG_LOCKDEP) + (defined(CONFIG_FTRACE) - defined(CONFIG_FTRACE_MCOUNT_RECORD)))
> +#define DEBUG_COUNT (defined(CONFIG_DEBUG_RT_MUTEXES) + defined(CONFIG_IRQSOFF_TRACER) + defined(CONFIG_PREEMPT_TRACER) + defined(CONFIG_INTERRUPT_OFF_HIST) + defined(CONFIG_PREEMPT_OFF_HIST) + defined(CONFIG_WAKEUP_LATENCY_HIST) + defined(CONFIG_DEBUG_SLAB) + defined(CONFIG_DEBUG_PAGEALLOC) + defined(CONFIG_LOCKDEP) + (defined(CONFIG_FTRACE) - defined(CONFIG_FTRACE_MCOUNT_RECORD)))
>  
>  #if DEBUG_COUNT > 0
>  	printk(KERN_ERR "*****************************************************************************\n");


