Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759984Ab2HIXQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 19:16:33 -0400
Received: from mga14.intel.com ([143.182.124.37]:51276 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754131Ab2HIXQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 19:16:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,742,1336374000"; 
   d="scan'208";a="178971484"
Message-ID: <502444CC.8030906@linux.intel.com>
Date: Thu, 09 Aug 2012 16:16:28 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Avi Kivity <avi@redhat.com>, Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] tracepoints: Move the work out of line from hotpath
 sections
References: <1344544823.6935.82.camel@gandalf.stny.rr.com>  <20120809205053.GB15109@Krystal> <1344551131.6935.90.camel@gandalf.stny.rr.com>
In-Reply-To: <1344551131.6935.90.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2012 03:25 PM, Steven Rostedt wrote:
>>
>> It might be better to improve gcc to move really cold branches out of
>> line (really, really far away), and use the compiler to do this, rather
>> than to use an extra indirection that adds bloat and complexity to the
>> kernel.
> 
> I think modifying gcc is something that can help more than tracing. But
> that's been a pipe dream for such a long time that I've started dreaming
> about winning a gold medal in the Olympics instead. Standing on the
> podium listening to the crowd chanting your name along with your country
> is more fun to dream about than seeing your unlikely code stop becoming
> hurdles for the CPU sprinters.
> 

At one point, maybe, but lately we have had a lot more traction from the
gcc developers, giving us features like __fentry__ and asm goto.

	-hpa

