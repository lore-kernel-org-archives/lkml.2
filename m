Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353Ab2JFAQV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 20:16:21 -0400
Received: from mga14.intel.com ([143.182.124.37]:38194 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865Ab2JFAQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 20:16:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,541,1344236400"; 
   d="scan'208";a="153034609"
Message-ID: <506F7849.2080805@zytor.com>
Date: Fri, 05 Oct 2012 17:16:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Seiji Aguchi <seiji.aguchi@hds.com>,
        "Thomas Gleixner (tglx@linutronix.de)" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "x86@kernel.org" <x86@kernel.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [PATCH v4] trace,x86: add x86 irq vector tracepoints
References: <A5ED84D3BB3A384992CBB9C77DEDA4D41385F33C@USINDEM103.corp.hds.com>  <50612729.2080307@zytor.com>  <A5ED84D3BB3A384992CBB9C77DEDA4D41386426D@USINDEM103.corp.hds.com>  <50650A7E.90807@zytor.com>  <A5ED84D3BB3A384992CBB9C77DEDA4D413869FD7@USINDEM103.corp.hds.com> <1349446428.6755.56.camel@gandalf.local.home>
In-Reply-To: <1349446428.6755.56.camel@gandalf.local.home>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2012 07:13 AM, Steven Rostedt wrote:
> 
> Peter,
> 
> I agree that the IDT version is a zero cost in performance, where as the
> tracepoint version is a negligible cost in performance. But my worry is
> the complexity (read error prone and possible openings of security
> exploits) worth it?
> 
> Switching of the IDT is not that trivial, and to make it something for
> common activities such as reading tracepoints by tools like ftrace and
> perf, that do it often, even on production machines, may lead to issues
> if its not done right.
> 

It's a table of pointers... there really isn't anything magic about it
(except perhaps the slightly weird format.)

> You are the maintainer and are responsible for the outcome of changes to
> the x86 arch, thus you do have final say. And if you think there's
> nothing to worry about with an IDT change then Seiji should implement
> it.
> 
> I just want to point out some possible repercussions of doing it in a
> more complex way. As tracepoints use nops, and I may be pushing to even
> out-of-line the tracepoint unlikely part even more, I'm not sure the
> complexity is worth the amount of savings it would be against just
> adding the tracepoint in the code.

The problem I'm seeing is the constant "oh, just a little bit more."  My
experience over the years is that there is always demand for "just one
more debug feature", each of which has negible cost, because they always
use the previous thing as a baseline... noone ever looks at the grand
total cost of the package (and by the time that happens, it is too late.)

tracepoints in particular are something I'm getting concerned about,
because they are one of those things that turn kernel internals into an
ABI, which means misdesigned tracepoints can actually make kernel
internal changes very hard to do.  The cost of those kinds of issues go
up over time as the strain between where we'd like the code to be vs.
where the code is increases.

	-hpa


