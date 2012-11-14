Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945998Ab2KNXaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 18:30:20 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9553 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945916Ab2KNXaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 18:30:18 -0500
X-Authority-Analysis: v=2.0 cv=dvhZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=MbCFXo7hY28A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=2HxqKFuZ9XIA:10 a=7YfXLusrAAAA:8 a=mExTbI_X2YBv08Y-INUA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1352935816.18025.75.camel@gandalf.local.home>
Subject: Re: [RFC] perf: need to expose sched_clock to correlate user
 samples with kernel samples
From: Steven Rostedt <rostedt@goodmis.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Will Deacon <will.deacon@arm.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Pekka Enberg <penberg@gmail.com>,
        Robert Richter <robert.richter@amd.com>, tglx <tglx@linutronix.de>
Date: Wed, 14 Nov 2012 18:30:16 -0500
In-Reply-To: <50A41A85.9090800@linaro.org>
References: <CABPqkBQALeD=iO9x-N0nw+shhqa1kmUaj=sCvx+MvoAPGQ-y9A@mail.gmail.com>
	 <1350408232.2336.42.camel@laptop> <509DB632.7070305@linaro.org>
	 <1352840337.18025.43.camel@gandalf.local.home>
	 <50A41A85.9090800@linaro.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-11-14 at 14:26 -0800, John Stultz wrote:

> > There's also trace_clock_counter() which isn't even a clock :-)  It's
> > just a incremental atomic counter that goes up every time it's called.
> > This is the most synced clock, but is absolutely meaningless for
> > timestamps. It's just a way to show ordered events.
> 
> Oof. This is getting uglier. I'd really prefer not to expose all these 
> different internal clocks out userland. Especially via clock_gettime().

Actually, I would be happy to just expose them to modules. As things
like hwlat_detect could use them.

-- Steve


