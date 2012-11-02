Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933279Ab2KBRrg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 13:47:36 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:8039 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932906Ab2KBRre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 13:47:34 -0400
Date: Fri, 2 Nov 2012 17:47:32 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Shan Wei <shanwei88@gmail.com>
cc: rostedt@goodmis.org, fweisbec@gmail.com,
        Kernel-Maillist <linux-kernel@vger.kernel.org>, mingo@redhat.com
Subject: Re: [PATCH v2 7/9] trace: use this_cpu_ptr per-cpu helper
In-Reply-To: <5093EE75.9040006@gmail.com>
Message-ID: <0000013ac23c254a-853c069d-2a95-4dec-a7a1-2e43f6c9b35b-000000@email.amazonses.com>
References: <5093EE75.9040006@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Nov 2012, Shan Wei wrote:

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

	return this_cpu_read(percpu_buffer->buffer)

and drop the this_cpu_ptr operation please.

