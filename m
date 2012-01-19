Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344Ab2ASBSr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 20:18:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:49240 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab2ASBSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 20:18:45 -0500
X-Authority-Analysis: v=2.0 cv=SqgSGYy0 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=saMF3w9JtD0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=dK0cnowJI7yv8UhGNyoA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=cmisVECafA1ZuOQO:21 a=o_jB8wEfgt-4rRn4:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1326935923.17534.94.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 1/5] ring_buffer: Export for_each_buffer_cpu()
From: Steven Rostedt <rostedt@goodmis.org>
To: Richard Weinberger <rw@linutronix.de>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>
Date: Wed, 18 Jan 2012 20:18:43 -0500
In-Reply-To: <1326926610-17830-2-git-send-email-rw@linutronix.de>
References: <1326926610-17830-1-git-send-email-rw@linutronix.de>
	 <1326926610-17830-2-git-send-email-rw@linutronix.de>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-18 at 23:43 +0100, Richard Weinberger wrote:
> From: Richard Weinberger <richard@nod.at>
> 

Missing change log.


Otherwise,

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  include/linux/ring_buffer.h |    5 +++++
>  kernel/trace/ring_buffer.c  |    7 +++++++
>  2 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
> index 67be037..5c1c29f 100644
> --- a/include/linux/ring_buffer.h
> +++ b/include/linux/ring_buffer.h
> @@ -185,4 +185,9 @@ enum ring_buffer_flags {
>  	RB_FL_OVERWRITE		= 1 << 0,
>  };
>  
> +cpumask_var_t *ring_buffer_mask(struct ring_buffer *buffer);
> +
> +#define for_each_buffer_cpu(buffer, cpu) \
> +	for_each_cpu(cpu, *(ring_buffer_mask(buffer)))
> +
>  #endif /* _LINUX_RING_BUFFER_H */
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index f5b7b5c..a4117c5 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -348,6 +348,7 @@ void *ring_buffer_event_data(struct ring_buffer_event *event)
>  }
>  EXPORT_SYMBOL_GPL(ring_buffer_event_data);
>  
> +#undef for_each_buffer_cpu
>  #define for_each_buffer_cpu(buffer, cpu)		\
>  	for_each_cpu(cpu, buffer->cpumask)
>  
> @@ -4139,3 +4140,9 @@ static int rb_cpu_notify(struct notifier_block *self,
>  	return NOTIFY_OK;
>  }
>  #endif
> +
> +cpumask_var_t *ring_buffer_mask(struct ring_buffer *buffer)
> +{
> +	return &buffer->cpumask;
> +}
> +EXPORT_SYMBOL_GPL(ring_buffer_mask);


