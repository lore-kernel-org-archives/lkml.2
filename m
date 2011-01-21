Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab1AUSkt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 13:40:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993Ab1AUSks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 13:40:48 -0500
Subject: Re: [BUG?] tracing/function_graph: set_graph_function was broken
 from 2.6.36-rc2
From: Steven Rostedt <srostedt@redhat.com>
To: wu zhangjin <wuzhangjin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        zhiping zhong <xzhong86@163.com>
In-Reply-To: <AANLkTin6g8SGnuG6j6JVCdBvOeiBj8Quwr2T9K+3jUwq@mail.gmail.com>
References: <AANLkTinxxOsXNatAiP0t8Vv0xFZcdSpoWWrG49g6JjqF@mail.gmail.com>
	 <1295544654.19789.19.camel@fedora>
	 <AANLkTin6g8SGnuG6j6JVCdBvOeiBj8Quwr2T9K+3jUwq@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Fri, 21 Jan 2011 13:40:31 -0500
Message-ID: <1295635231.26768.2.camel@fedora>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-21 at 17:27 +0800, wu zhangjin wrote:
> On Fri, Jan 21, 2011 at 1:30 AM, Steven Rostedt <srostedt@redhat.com> wrote:

> >> trace_graph_entry():
> >>
> >>         [snip]
> >>         /* trace it when it is-nested-in or is a function enabled. */
> >>         if (!(trace->depth || ftrace_graph_addr(trace->func)) ||
> >>               ftrace_graph_ignore_irqs())
> >>                 return 0;
> >>         [snip]
> >>
> 
> By default, ftrace_graph_ignore_irqs() is false, then, if we don't put
> 0 to /debug/tracing/options/funcgraph-irqs, it will not return even if
> we have specified some entries through the tracing/set_graph_function
> interface, as a result, every function will be traced and it doesn't
> work as we expected, the expected result is only the specified
> functions are reserved in the tracing result.
> 

???

It's an or, if the first case is true:

  !(trace->depth || ftrace_graph_addr(trace->func))

then we return and do not trace. Regardless of what
ftrace_graph_ignore_irqs() is set to.

Can you show me an example of what you are having a problem with?

-- Steve


