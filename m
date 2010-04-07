Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389Ab0DGBNU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 21:13:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:64825 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932357Ab0DGBNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 21:13:13 -0400
X-Authority-Analysis: v=1.1 cv=1G73JCAd+9Vhhx30tk0+Sc/rngIYAy4Ia+6Xn7XSY0k= c=1 sm=0 a=b8JJ-gGZIcIA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8 a=UxzebxvuqytF1Yl13_4A:9 a=K7G30RjTJqbyEnRjZ7oA:7 a=V6meeIfb96HTq4lDLb_JY3k8MdAA:4 a=PUjeQqilurYA:10 a=x8gzFH9gYPwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [patch 1/3] kernel: local_irq_{save,restore}_nmi()
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@elte.hu, David Miller <davem@davemloft.net>, acme@redhat.com,
       paulus@samba.org, Mike Galbraith <efault@gmx.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <20100406133140.903644813@chello.nl>
References: <20100406132807.698467930@chello.nl>
	 <20100406133140.903644813@chello.nl>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 06 Apr 2010 21:13:10 -0400
Message-ID: <1270602790.19685.15603.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-06 at 15:28 +0200, Peter Zijlstra wrote:

> Index: linux-2.6/kernel/trace/trace_irqsoff.c
> ===================================================================
> --- linux-2.6.orig/kernel/trace/trace_irqsoff.c
> +++ linux-2.6/kernel/trace/trace_irqsoff.c
> @@ -316,6 +316,14 @@ void trace_hardirqs_off(void)
>  }
>  EXPORT_SYMBOL(trace_hardirqs_off);
>  
> +void trace_hardirqs_off_no_nmi(void)
> +{
> +	WARN_ON_ONCE(in_nmi());

Should we do this for all archs? I can imagine a lot of warning reports
coming in the near future. And they will be passing it towards me.

-- Steve



> +	if (!preempt_trace() && irq_trace())
> +		start_critical_timing(CALLER_ADDR0, CALLER_ADDR1);
> +}
> +EXPORT_SYMBOL(trace_hardirqs_off_no_nmi);
> +
>  void trace_hardirqs_on_caller(unsigned long caller_addr)
>  {
>  	if (!preempt_trace() && irq_trace())
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


