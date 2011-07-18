Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242Ab1GRPMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 11:12:41 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:45216 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab1GRPMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 11:12:40 -0400
Date: Mon, 18 Jul 2011 17:12:33 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: rostedt@goodmis.org, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC 3/4] perf, ftrace: Add new perf ioctl for function trace
 filter
Message-ID: <20110718151229.GA32167@somewhere>
References: <1310390576-8289-1-git-send-email-jolsa@redhat.com>
 <1310390576-8289-4-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310390576-8289-4-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 03:22:55PM +0200, Jiri Olsa wrote:
> As the amount of kernel functions obtained by the ftrace:function tracepoint
> is quite big, it's desirable to be able to set the filter on the ftrace
> level.
> 
> Added PERF_EVENT_IOC_SET_FTRACE ioctl to be able to specify function filter
> for perf event. The interface is the same as for the set_ftrace_filter file.
> 
> Also the same string parser is used as for the set_ftrace_filter file.

I'm not sure I understand why an ioctl is needed for that.
Why not using the ftrace filter?

The first idea was to do something like this:

	ip == func1 || ip == func2 || ....

But that makes a too long expression. So I thought we
could bring support for the "+" operator and have expressions
like:

	ip == func1 + func2 + func3 + ....

	ip == !func1
