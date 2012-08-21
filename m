Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab2HUNlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 09:41:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6195 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab2HUNlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 09:41:18 -0400
X-Authority-Analysis: v=2.0 cv=LIjkseq9 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=07ZCQtT27sEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ZRzJ3tYFNvQA:10 a=meVymXHHAAAA:8 a=KpnN13Z4PWoOmvqJTicA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1345556475.5069.3.camel@gandalf.local.home>
Subject: Re: [RFC PATCH -v2 0/4] Persistent events
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 21 Aug 2012 09:41:15 -0400
In-Reply-To: <20120821131136.GC21432@aftab.osrc.amd.com>
References: <1345139123-15212-1-git-send-email-bp@amd64.org>
	 <1345545050.23018.95.camel@twins>
	 <20120821131136.GC21432@aftab.osrc.amd.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-21 at 15:11 +0200, Borislav Petkov wrote:
> On Tue, Aug 21, 2012 at 12:30:50PM +0200, Peter Zijlstra wrote:
> > Good progress there, there's still a few things though:
> > 
> >  - the point also raised by Steven, I'm pretty sure that the placing of
> >    the debugfs files unfortunate. I would much rather see something
> >    like /debug/perf/persistent/$foo, also dropping your
> >    perf_event_desc::dir_name.
> 
> Ok, how do we want to do the per-CPU layout there? Like this:
> 
> /debug/perf/persistent/mce_record0
> /debug/perf/persistent/mce_record1
> ...
> 
> or rather
> 
> /debug/perf/persistent/cpu0/mce_record
> /debug/perf/persistent/cpu1/mce_record
> 
> ?

Definitely the second one. The first one is just ugly. The second is
more in line to the tracing directories too:

/debug/tracing/per_cpu/cpu0/...

-- Steve


