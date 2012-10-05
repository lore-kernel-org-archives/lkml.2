Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932440Ab2JEQ7N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 12:59:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32354 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756906Ab2JEQ7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 12:59:09 -0400
X-Authority-Analysis: v=2.0 cv=fb8vOjsF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=VW4PT0HfPecA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=RH7umM2CMQ4A:10 a=3nbZYyFuAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=t8SATrHsGyiI7lZRys8A:9 a=PUjeQqilurYA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1349456348.6755.59.camel@gandalf.local.home>
Subject: Re: [PATCH -tip 2/4] tracing: add a resize function for making one
 buffer equivalent to the other buffer
From: Steven Rostedt <rostedt@goodmis.org>
To: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Cc: linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Date: Fri, 05 Oct 2012 12:59:08 -0400
In-Reply-To: <20121002082715.9807.90791.stgit@falsita>
References: <20121002081309.8661.37629.stgit@falsita>
	 <20121002082715.9807.90791.stgit@falsita>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-02 at 17:27 +0900, Hiraku Toyooka wrote:
> Trace buffer size is now per-cpu, so that there are following two
> patterns in resize of the buffers.
> 
>   (1) resize per-cpu buffers to same given size
>   (2) resize per-cpu buffers to the other trace_array's buffer size
>       for each CPU (such as preparing the max_tr which is equivalent
>       to the global_trace's size)
> 
> __tracing_resize_ring_buffer() can be used for (1), and had
> implemented (2) inside it for resetting the global_trace to the
> original size.
> 
> (2) was also implemented in other place. So this patch assembles
> them in a new function - resize_buffer_even().
> 
> Signed-off-by: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: linux-kernel@vger.kernel.org
> ---
> 
>  kernel/trace/trace.c |   57 ++++++++++++++++++++++++++------------------------
>  1 files changed, 30 insertions(+), 27 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 08acf42..1e599e6 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -3017,6 +3017,31 @@ static void set_buffer_entries(struct trace_array *tr, unsigned long val)
>  		tr->data[cpu]->entries = val;
>  }
>  
> +/* resize @tr's buffer to the size of @size_tr's entries */
> +static int resize_buffer_even(struct trace_array *tr,

I don't mind this patch, but I just hate the name "resize_buffer_even".
What about "resize_buffer_duplicate_size"?

-- Steve


