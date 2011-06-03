Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab1FCPCz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 11:02:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57727 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab1FCPCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 11:02:54 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=zVV6AOFjHgwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=f2PZ6FAIbhRmRNlPUvkA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCHv2 1/5] tracing, function_graph: Remove dependency of
 abstime and duration fields on latency
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <1307113131-10045-2-git-send-email-jolsa@redhat.com>
References: <1307111215.3667.53.camel@gandalf.stny.rr.com>
	 <1307113131-10045-1-git-send-email-jolsa@redhat.com>
	 <1307113131-10045-2-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 03 Jun 2011 11:02:53 -0400
Message-ID: <1307113373.3667.60.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-03 at 16:58 +0200, Jiri Olsa wrote:

> With following commands:
> 	# echo function_graph > ./current_tracer
> 	# cat trace
> 
> This is what it looked like before:
> # tracer: function_graph
> #
> #     TIME        CPU  DURATION                  FUNCTION CALLS
> #      |          |     |   |                     |   |   |   |
>  0)   0.068 us    |          } /* page_add_file_rmap */
>  0)               |          _raw_spin_unlock() {
> ...
> 
> This is what it looks like now:
> # tracer: function_graph
> #
> # CPU  DURATION                  FUNCTION CALLS
> # |     |   |                     |   |   |   |
>  0)   0.068 us    |                } /* add_preempt_count */
>  0)   0.993 us    |              } /* vfsmount_lock_local_lock */
> ...

Much nicer change log.

Thanks!

Seems that every patch I test I stumble across another (unrelated) bug.
And then I get side tracked into fixing that bug. So it may be a while
before I get to these.

-- Steve


