Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759573Ab2JLB47 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 21:56:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21510 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759550Ab2JLB45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 21:56:57 -0400
X-Authority-Analysis: v=2.0 cv=a96yBDuF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=J7ERXNQwqmwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=P3xNwfJ5JkoA:10 a=1XWaLZrsAAAA:8 a=6V5PVwrkk0rYTD7v0FkA:9 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=1f7l125domMVR3D3:21 a=t_0lioJAi1htS1vH:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1350007016.24256.82.camel@gandalf.local.home>
Subject: Re: [PATCH 1/2] tracing: trivial cleanup
From: Steven Rostedt <rostedt@goodmis.org>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Justin Teravest <teravest@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 11 Oct 2012 21:56:56 -0400
In-Reply-To: <1339112785-21806-1-git-send-email-vnagarnaik@google.com>
References: <1339112785-21806-1-git-send-email-vnagarnaik@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I know this is late, but it was pushed down in my todo list
(never off, but something I probably wouldn't have seen for a few more
months).

On Thu, 2012-06-07 at 16:46 -0700, Vaibhav Nagarnaik wrote:
> From: David Sharp <dhsharp@google.com>

If this is from David it needs his SOB.

-- Steve

> 
> Remove ftrace_format_syscall() declaration; it is neither defined nor
> used. Also update a comment and formatting.
> 
> Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
> ---
>  include/trace/syscall.h    |    2 --
>  kernel/trace/ring_buffer.c |    6 +++---
>  2 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/include/trace/syscall.h b/include/trace/syscall.h
> index 31966a4..0c95796 100644
> --- a/include/trace/syscall.h
> +++ b/include/trace/syscall.h
> @@ -39,8 +39,6 @@ extern int reg_event_syscall_enter(struct ftrace_event_call *call);
>  extern void unreg_event_syscall_enter(struct ftrace_event_call *call);
>  extern int reg_event_syscall_exit(struct ftrace_event_call *call);
>  extern void unreg_event_syscall_exit(struct ftrace_event_call *call);
> -extern int
> -ftrace_format_syscall(struct ftrace_event_call *call, struct trace_seq *s);
>  enum print_line_t print_syscall_enter(struct trace_iterator *iter, int flags,
>  				      struct trace_event *event);
>  enum print_line_t print_syscall_exit(struct trace_iterator *iter, int flags,
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 1d0f6a8..96c2dd1 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -1816,7 +1816,7 @@ rb_add_time_stamp(struct ring_buffer_event *event, u64 delta)
>  }
>  
>  /**
> - * ring_buffer_update_event - update event type and data
> + * rb_update_event - update event type and data
>   * @event: the even to update
>   * @type: the type of event
>   * @length: the size of the event field in the ring buffer
> @@ -2716,8 +2716,8 @@ EXPORT_SYMBOL_GPL(ring_buffer_discard_commit);
>   * and not the length of the event which would hold the header.
>   */
>  int ring_buffer_write(struct ring_buffer *buffer,
> -			unsigned long length,
> -			void *data)
> +		      unsigned long length,
> +		      void *data)
>  {
>  	struct ring_buffer_per_cpu *cpu_buffer;
>  	struct ring_buffer_event *event;


