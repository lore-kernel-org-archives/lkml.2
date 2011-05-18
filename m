Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268Ab1ERXhX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 19:37:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:55783 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756170Ab1ERXhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 19:37:22 -0400
X-Authority-Analysis: v=1.1 cv=ou1QuR4lBR9YeJgEH9ccYmbAdaWqVVq3lOvCKJtMpGM= c=1 sm=0 a=YGpKOGB3rUAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=yjhGIhWdcR5t9q172RIA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] tracing: Register static events output early
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1305761368-5488-1-git-send-email-fweisbec@gmail.com>
References: <1305761368-5488-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 18 May 2011 19:37:19 -0400
Message-ID: <1305761839.11267.23.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-19 at 01:29 +0200, Frederic Weisbecker wrote:

> diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
> index cf535cc..ad92d9c 100644
> --- a/kernel/trace/trace_output.c
> +++ b/kernel/trace/trace_output.c
> @@ -1278,4 +1278,4 @@ __init static int init_events(void)
>  
>  	return 0;
>  }
> -device_initcall(init_events);
> +early_initcall(init_events);

Hmm, careful here. The ring buffers are also allocated at early_init().

But you may be OK, as things like trace_printk() don't do anything if
"tracing_disabled" is set, and it's set on bootup and cleared after we
allocate the buffers.

-- Steve


