Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab2DXA4a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 20:56:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:25167 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755222Ab2DXA43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 20:56:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="145068909"
Message-ID: <1335229007.14538.43.camel@ymzhang.sh.intel.com>
Subject: Re: [RFC 1/2] kernel patch for dump user space stack tool
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Cong Wang <xiyou.wangcong@gmail.com>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>, Lin Ming <mlin@ss.pku.edu.cn>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "Zuo, Jiao" <jiao.zuo@intel.com>
Date: Tue, 24 Apr 2012 08:56:47 +0800
In-Reply-To: <1334914719.2463.32.camel@laptop>
References: <EE928378561BF1449699C96571234A740FCED62F@SHSMSX101.ccr.corp.intel.com>
	 <4F8F8B9E.3040107@gmail.com>
	 <1334812653.14538.29.camel@ymzhang.sh.intel.com>
	 <1334914719.2463.32.camel@laptop>
Organization: MCG
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-20 at 11:38 +0200, Peter Zijlstra wrote:
> On Thu, 2012-04-19 at 13:17 +0800, Yanmin Zhang wrote:
> > Although not checking the source codes of pstack (sorry, I'm busy in debugging
> > many critical issues), I think pstack is based on ptrace interface, which means:
> > 1) It need traps into system for many times to collect call frames of one
> > task.
> > 2) It need send signal to the ptraced process to stop it. Such behavior
> > might have some impact if the ptraced process also processes many signals.
> 
> Yeah, but who cares.. its debugging stuff..
Real developers, real debuggers care it. End users don't care it.

> 
> > 3) The data parsing to get symbols might not be split from data collection.
> > I mean, it collects call frames of one process, then parses it; then collects the 2nd
> > task's. If there are many processes, it couldn't collect the data just at the monitor
> > time point. 
> 
> This is equally true for your silly patch.
Not true for my patch. We did many experiments. Originally, we used
the similar method like pstack based on ptrace and found it's
very slow to do so when getting all the stacks of all processes
when system reports an issue.

Anyway, thanks for taking your time to look at it.


