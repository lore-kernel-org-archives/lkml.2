Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759582Ab2JaRuR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:50:17 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:40638 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758928Ab2JaRuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:50:15 -0400
Date: Wed, 31 Oct 2012 17:50:14 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Shan Wei <shanwei88@gmail.com>
cc: rostedt@goodmis.org, fweisbec@gmail.com,
        Kernel-Maillist <linux-kernel@vger.kernel.org>, mingo@redhat.com
Subject: Re: [PATCH 8/9] trace: use this_cpu_ptr per-cpu helper
In-Reply-To: <50910A1E.3040009@gmail.com>
Message-ID: <0000013ab7f1e47a-68c5ce3c-06bb-48f8-93f7-1ce012b36a75-000000@email.amazonses.com>
References: <50910A1E.3040009@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2012, Shan Wei wrote:

> From: Shan Wei <davidshan@tencent.com>
>
>
> Signed-off-by: Shan Wei <davidshan@tencent.com>
> ---
>  kernel/trace/blktrace.c |    2 +-
>  kernel/trace/trace.c    |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
> index c0bd030..71259e2 100644
> --- a/kernel/trace/blktrace.c
> +++ b/kernel/trace/blktrace.c
> @@ -147,7 +147,7 @@ void __trace_note_message(struct blk_trace *bt, const char *fmt, ...)
>  		return;
>
>  	local_irq_save(flags);
> -	buf = per_cpu_ptr(bt->msg_data, smp_processor_id());
> +	buf = this_cpu_ptr(bt->msg_data);
>  	va_start(args, fmt);
>  	n = vscnprintf(buf, BLK_TN_MAX_MSG, fmt, args);
>  	va_end(args);

Ok

> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 31e4f55..81ae35b 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -1513,7 +1513,7 @@ static char *get_trace_buf(void)
>  	if (!percpu_buffer)
>  		return NULL;
>
> -	buffer = per_cpu_ptr(percpu_buffer, smp_processor_id());
> +	buffer = this_cpu_ptr(percpu_buffer);
>
>  	return buffer->buffer;


Just do a

	return this_cpu_read(percpu_buffer->buffer);

and get rid of the this_cpu_ptr op
