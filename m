Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab2KTBRJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 20:17:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18764 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab2KTBRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 20:17:07 -0500
X-Authority-Analysis: v=2.0 cv=f9bK9ZOM c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=yHbJst7BUucA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=eYYPdsDFe-UA:10 a=rWYUxwV3Lchv5pqS5qgA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1353374226.6276.16.camel@gandalf.local.home>
Subject: Re: [PATCH] nohz/cpuset: Make a CPU stick with do_timer() duty in
 the presence of nohz cpusets
From: Steven Rostedt <rostedt@goodmis.org>
To: Hakan Akkan <hakanakkan@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Date: Mon, 19 Nov 2012 20:17:06 -0500
In-Reply-To: <CABVzNXqVdgTr1GNN6_yj-CZTDLPtP=Ok7r5TaDbRt2jpxHB-5Q@mail.gmail.com>
References: <4FDD7AA8.6080601@gmail.com>
	 <CAFTL4hy4SedXQ1Bc6o_1BHZ-7a8tbbvpUcFwp50hDbgNnv79zQ@mail.gmail.com>
	 <CABVzNXqVdgTr1GNN6_yj-CZTDLPtP=Ok7r5TaDbRt2jpxHB-5Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-19 at 17:27 -0700, Hakan Akkan wrote:

> >
> > I suggest to rather define a tunable timekeeping duty CPU affinity in
> > a cpumask file at /sys/devices/system/cpu/timekeeping and a toggle at
> > /sys/devices/system/cpu/cpuX/timekeeping (like the online file). This
> > way the user can decide whether adaptive nohz CPU can handle
> > timekeeping or this must be forced to other CPUs in order to enforce
> > isolation.
> 
> Well, users want tickless CPUs because they don't want timekeeping
> (or any other kernel activity for that matter) to run in there. So, I believe
> having that "timekeeping affinity" stay in the regular CPUs is good enough.
> Please let me know how users could utilize these control files to do anything
> other than keeping the timekeeping out of adaptive nohz CPUs.

I agree. If we already have some /sys cpumask that denotes which CPUs
will be adaptive NO_HZ (or simply isolated) then just keep the tick from
ever going on those CPUs. If all but one CPU is set for nohz, and that
one CPU goes idle, it should still be the one doing the tick.

-- Steve


