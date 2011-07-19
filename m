Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767Ab1GSJ5r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 05:57:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657Ab1GSJ5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 05:57:44 -0400
Date: Tue, 19 Jul 2011 11:57:27 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: rostedt@goodmis.org, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC 3/4] perf, ftrace: Add new perf ioctl for function trace
 filter
Message-ID: <20110719095727.GA3008@jolsa.brq.redhat.com>
References: <1310390576-8289-1-git-send-email-jolsa@redhat.com>
 <1310390576-8289-4-git-send-email-jolsa@redhat.com>
 <20110718151229.GA32167@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110718151229.GA32167@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 05:12:33PM +0200, Frederic Weisbecker wrote:
> On Mon, Jul 11, 2011 at 03:22:55PM +0200, Jiri Olsa wrote:
> > As the amount of kernel functions obtained by the ftrace:function tracepoint
> > is quite big, it's desirable to be able to set the filter on the ftrace
> > level.
> > 
> > Added PERF_EVENT_IOC_SET_FTRACE ioctl to be able to specify function filter
> > for perf event. The interface is the same as for the set_ftrace_filter file.
> > 
> > Also the same string parser is used as for the set_ftrace_filter file.
> 
> I'm not sure I understand why an ioctl is needed for that.
> Why not using the ftrace filter?
> 
> The first idea was to do something like this:
> 
> 	ip == func1 || ip == func2 || ....

The part where I got stuck is when you start to combine the fields
in the filter like:

	ip == func1 || ip_parent != func2
	ip == func1 || (ip == func2 && ip_parent != func3)

Which is ok when all functions are enabled and ip/parent_ip fields
are treated as values. But I'd need enable proper set of functions
based on above filter parsing.. which might not be that easy :)

So I thought it'd be easier to have the filter as above,
plus you could specify the amount of traced functions with
ioctl command.

> 
> But that makes a too long expression. So I thought we
> could bring support for the "+" operator and have expressions
> like:
> 
> 	ip == func1 + func2 + func3 + ....
> 
> 	ip == !func1

So would you like to have just simple filter for function event?
(embedded into the current event filter..) like:

	ip == func1 + func2 + func3 + 

Support just one 'ip' field and whatever we got in the parameter
we put into the ftrace filter.. ?

thanks,
jirka
