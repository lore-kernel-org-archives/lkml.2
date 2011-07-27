Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab1G0MRz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 08:17:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303Ab1G0MRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 08:17:53 -0400
Date: Wed, 27 Jul 2011 14:17:34 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: rostedt@goodmis.org, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC 3/4] perf, ftrace: Add new perf ioctl for function trace
 filter
Message-ID: <20110727121734.GB2605@jolsa.brq.redhat.com>
References: <1310390576-8289-1-git-send-email-jolsa@redhat.com>
 <1310390576-8289-4-git-send-email-jolsa@redhat.com>
 <20110718151229.GA32167@somewhere>
 <20110719095727.GA3008@jolsa.brq.redhat.com>
 <20110726134327.GA1779@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110726134327.GA1779@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 03:43:44PM +0200, Frederic Weisbecker wrote:

SNIP

> Ideally, the filter engine should split expressions into a tree
> of ops:
> 
> 	ip == func1 + func2 + func3 || ip == func4
> 
> should be parsed into:
> 
>             ||
>             /\
>            /  \
>           /    \
>          /      \
>         ==       ==
>        /  \     /  \
>       /    \   ip   \
>      /      \       func4
>     ip       +       
>             / \
>            /   \
>           +     \
>          /  \   func3
>         /    \
>     func1   func2
> 
> And then pass that to ftrace that interprets that tree
> by building set of functions on top of each node joined to
> the other.
> 
> But that can be complicated to do, and perhaps a bit of
> an overkill even for daily use of it.
> 
> Having a simple "ip == func + func2 + func3" expression support

so the '+' is just shortcut for '||' ... like:

"ip == x1 || ip == x1" AND "ip == x1 + x2" mean the same thing

if we omit the '+' and keep just the whitespace we could use the function
name parser as used in set_ftrace_filter interface with no change ;)
but adding new separator should not be that hard..

> should be enough I think. And we can reject expressions that don't
> fit that pattern. Then if it becomes necessary one day to support
> real expressions there, we can still switch to a real tree.
> 
> Does that look sane? 

I'l make the change and send new version

thanks,
jirka
