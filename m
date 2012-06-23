Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab2FWMEk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 08:04:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:20291 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808Ab2FWMEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 08:04:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="169228900"
Date: Sat, 23 Jun 2012 20:04:33 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Kay Sievers <kay@vrfy.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "kay.sievers" <kay.sievers@vrfy.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] printk: Add printk_flush() to force buffered text to
 console
Message-ID: <20120623120433.GA10789@localhost>
References: <1340322723.27036.220.camel@gandalf.stny.rr.com>
 <20120622145402.8047a669.akpm@linux-foundation.org>
 <20120623061313.GA21895@gmail.com>
 <1340452052.1784.40.camel@mop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340452052.1784.40.camel@mop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> - printing one full line, and suppress the later OK entirely. The OK
>   might not be needed at all; we will find out that the machine
>   has not crashed at that point and a message in case of an error
>   could be sufficient in most cases.

That looks neat and feasible.  We not only get less output, but also
eliminate the problem of flushing:

        [   16.309109] Testing tracer irqsoff: PASSED
        [   17.184240] Testing tracer wakeup: PASSED
        [   18.060218] Testing tracer wakeup_rt: PASSED
        [   18.729222] Testing tracer function_graph: PASSED
        ...thousands more lines
=>
        [   16.309109] Testing tracer irqsoff
        [   17.184240] Testing tracer wakeup
        [   18.060218] Testing tracer wakeup_rt
        [   18.729222] Testing tracer function_graph
        ...thousands more lines

However these two special lines will have to be broken up into more lines:

        [   14.947553] Testing dynamic ftrace ops #1: (1 0 1 1 0) (1 1 2 1 0) (2 1 3 1 26) (2 2 4 1 43) PASSED
        [   15.740993] Testing dynamic ftrace ops #2: (1 0 1 26 0) (1 1 2 43 0) (2 1 3 1 15) (2 2 4 18 32) PASSED

Thanks,
Fengguang
