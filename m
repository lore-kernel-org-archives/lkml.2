Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab2JLBgy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 21:36:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13091 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab2JLBgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 21:36:53 -0400
X-Authority-Analysis: v=2.0 cv=e+uEuNV/ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=1NXOQURvsMQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=SV3qqxZrFRMA:10 a=1XWaLZrsAAAA:8 a=gu6fZOg2AAAA:8 a=1dmK_P3i170RXgQm5O4A:9 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=jeBq3FmKZ4MA:10 a=GC8p-B92FUEA:10 a=NWVoK91CQyQA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1350005812.24256.81.camel@gandalf.local.home>
Subject: Re: [PATCH v6 6/6] tracing: Fix maybe-uninitialized warning in
 ftrace_function_set_regexp
From: Steven Rostedt <rostedt@goodmis.org>
To: David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 11 Oct 2012 21:36:52 -0400
In-Reply-To: <1349998076-15495-7-git-send-email-dhsharp@google.com>
References: <1349998076-15495-1-git-send-email-dhsharp@google.com>
	 <1349998076-15495-7-git-send-email-dhsharp@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-11 at 16:27 -0700, David Sharp wrote:
> Compiler warning:
> 
> kernel/trace/trace_events_filter.c: In function 'ftrace_function_set_filter_cb':
> kernel/trace/trace_events_filter.c:2074:8: error: 'ret' may be used uninitialized in this function [-Werror=maybe-uninitialized]
> 
> Signed-off-by: David Sharp <dhsharp@google.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/trace_events_filter.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
> index 431dba8..ef36953 100644
> --- a/kernel/trace/trace_events_filter.c
> +++ b/kernel/trace/trace_events_filter.c
> @@ -2002,9 +2002,10 @@ static int ftrace_function_set_regexp(struct ftrace_ops *ops, int filter,
>  static int __ftrace_function_set_filter(int filter, char *buf, int len,
>  					struct function_filter_data *data)
>  {
> -	int i, re_cnt, ret;
> +	int i, re_cnt;
>  	int *reset;
>  	char **re;
> +	int ret = 0;
>  
>  	reset = filter ? &data->first_filter : &data->first_notrace;
>  

It has already been fixed in mainline:

92d8d4a8b0f4c6eba70f6e62b48e38bd005a56e6

http://marc.info/?l=linux-kernel&m=134012157512078

-- Steve

