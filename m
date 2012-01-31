Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab2AaMue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 07:50:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41819 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab2AaMuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 07:50:32 -0500
X-Authority-Analysis: v=2.0 cv=MaXuSuDf c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=0LOP1KteNnsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=aIr8HDLft-_tD_DwsGIA:9 a=XQkh1KdNiMvYsTn6tz4A:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1328014230.5882.29.camel@gandalf.stny.rr.com>
Subject: Re: [RFC][PATCH] tracing/module: Move tracepoint out of module.h
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>
Date: Tue, 31 Jan 2012 07:50:30 -0500
In-Reply-To: <20120131122016.GF32010@elte.hu>
References: <1327545664.22710.78.camel@gandalf.stny.rr.com>
	 <20120126102836.GD3853@elte.hu>
	 <1327585945.22710.87.camel@gandalf.stny.rr.com>
	 <20120126135504.GA13107@elte.hu>
	 <1327586669.22710.89.camel@gandalf.stny.rr.com>
	 <1327588606.22710.100.camel@gandalf.stny.rr.com>
	 <20120126183946.GA14709@elte.hu> <87ehuldf0m.fsf@rustcorp.com.au>
	 <1327924333.22710.157.camel@gandalf.stny.rr.com>
	 <87sjiwjzew.fsf@rustcorp.com.au> <20120131122016.GF32010@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-31 at 13:20 +0100, Ingo Molnar wrote:

> > Saves only 400 bytes of text here, but I don't do preempt or 
> > tracepoints.
> 
> Most distro kernels do tracepoints so I guess that's where the 
> size delta comes from :-) In any case:

Yes, having tracepoints inlined causes a lot of bloat. But I still did
get a 1799 bytes savings between moving the tracepoint out of line but
keeping the if, and totally moving the entire functions out of line. Not
sure what the discrepancy was there.

My last set of numbers came from the default 3.0.0 Debian config, which
probably adds more things that call these functions into the kernel
proper?

But anway, I think this bike shed is complete ;-)

> 
> Acked-by: Ingo Molnar <mingo@elte.hu>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


