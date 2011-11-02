Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab1KBXIB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 19:08:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:38475 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013Ab1KBXH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 19:07:59 -0400
X-Authority-Analysis: v=1.1 cv=dCTC1p3vNTdx1H6U0HtbMKjJ9bTEtPwCLJ4qOUv6lx4= c=1 sm=0 a=CMzmyBkqurIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=6rqHouBjAAAA:8 a=Yvx-4ny5KTsOycQO2HUA:9 a=PUjeQqilurYA:10 a=TAmEwCHjoHMA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1320275277.4793.54.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] event: fix TP_printk() argument in sched_switch
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, devel@openvz.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Date: Wed, 02 Nov 2011 19:07:57 -0400
In-Reply-To: <1320273611-2463347-1-git-send-email-avagin@openvz.org>
References: <1320273611-2463347-1-git-send-email-avagin@openvz.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-03 at 01:40 +0300, Andrew Vagin wrote:
> process_arg(...) can't parse "__entry->prev_state & (TASK_STATE_MAX-1)",
> because a complicated argument should be within brackets.

No it is fine, the userspace tool is broken.

> 
> Without this patch "perf report" prints following errors:
> $ ./perf record -ag -e sched:sched_switch
> ...
> $ ./perf report
>   Warning: Error: expected type 5 but read 4
>   Warning: Error: expected type 4 but read 0
>   Fatal: bad op token {
> 
> Signed-off-by: Andrew Vagin <avagin@openvz.org>

NACK!

This is a perf userspace bug, not a kernel one. Please fix the userspace
tool instead.

Note, the new version of libparsevent handles this case without issue.
Perf just needs to be updated.

-- Steve

> ---
>  include/trace/events/sched.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
> index 959ff18..1838237 100644
> --- a/include/trace/events/sched.h
> +++ b/include/trace/events/sched.h
> @@ -140,7 +140,7 @@ TRACE_EVENT(sched_switch,
>  	TP_printk("prev_comm=%s prev_pid=%d prev_prio=%d prev_state=%s%s ==> next_comm=%s next_pid=%d next_prio=%d",
>  		__entry->prev_comm, __entry->prev_pid, __entry->prev_prio,
>  		__entry->prev_state & (TASK_STATE_MAX-1) ?
> -		  __print_flags(__entry->prev_state & (TASK_STATE_MAX-1), "|",
> +		  __print_flags((__entry->prev_state & (TASK_STATE_MAX-1)), "|",
>  				{ 1, "S"} , { 2, "D" }, { 4, "T" }, { 8, "t" },
>  				{ 16, "Z" }, { 32, "X" }, { 64, "x" },
>  				{ 128, "W" }) : "R",


