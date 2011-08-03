Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab1HCJzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 05:55:32 -0400
Received: from mx7.orcon.net.nz ([219.88.242.57]:35416 "EHLO mx7.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753565Ab1HCJz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 05:55:28 -0400
X-Greylist: delayed 5296 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Aug 2011 05:55:27 EDT
Message-ID: <4E39065C.6020801@orcon.net.nz>
Date: Wed, 03 Aug 2011 20:27:08 +1200
From: Michael Cree <mcree@orcon.net.nz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110702 Icedove/3.0.11
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH 6/7] perf, x86: Example code for AMD IBS
References: <1311860812-28748-1-git-send-email-robert.richter@amd.com>	 <1311860812-28748-7-git-send-email-robert.richter@amd.com>	 <1311958729.5890.413.camel@twins>  <20110801055008.GZ4590@erda.amd.com> <1312281474.1147.40.camel@twins>
In-Reply-To: <1312281474.1147.40.camel@twins>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-DSPAM-Check: by mx7.orcon.net.nz on Wed, 03 Aug 2011 20:27:09 +1200
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Wed Aug  3 20:27:10 2011
X-DSPAM-Confidence: 0.6528
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/11 22:37, Peter Zijlstra wrote:
> On Mon, 2011-08-01 at 07:50 +0200, Robert Richter wrote:
>> On 29.07.11 12:58:49, Peter Zijlstra wrote:
>>> On Thu, 2011-07-28 at 15:46 +0200, Robert Richter wrote:
>>>>  tools/perf/Documentation/examples/ibs.c    |  436 ++++++++++++++++++++++++++++
>>>
>>> That really isn't the place for this..
>>>
>>> Also, how similar is the Alpha PMU to AMD IBS?

The Alpha PMU (on the EV67 and later CPUs) has two counter modes:
"Aggregate" which is like counters on other CPUs and implemented in the
kernel, and "ProfileMe", which is not currently used in the perf. event
subsystem.

In the "ProfileMe" mode a counter is initialised with max_count-N and
when the counter overflows (i.e. after execution of ~N instructions) a
window is opened for profiling.  The window closes (roughly) when the
profiled instruction is retired from the pipeline.  The two counters
count events such as instructions, cycles, Bcache misses, etc. during
the window.  When the window is closed an interrupt to the PMU interrupt
handler is made.  The two counters can be read and there are other
registers that can be read that provide information on the profiled
instruction's flight through the pipeline, such as instruction killed
before being mapped (i.e. it was identified as a nop), instruction
stalled between fetch and being mapped (usually due to operands not data
ready), branch direction and branch misprediction (if instruction is a
branch), instruction was in a new Icache fill stream, instruction
trapped and trap type, and so on.

>> Would you prefer
>>
>>  tools/perf/Documentation/examples/x86/ibs.c
>>
>> instead?
> 
> Possibly, but having just looked at the example again I don't really see
> it doing anything perf-record doesn't already do, so why does it deserve
> to live at all?
> 
> Initially I thought it was a record+report like example, some code
> interpreting the 'mess' that comes out of IBS would be most appreciated
> and I think we can even ship that as perf-ibs-report/perf-ibs-annotate
> or so (and if its still remotely similar to its Alpha precursor that
> might make the Alpha folks happy too).

Sure would be nice if the infrastructure to support ProfileMe mode
appeared in the perf. events subsystem.  I am not going to go full out
to implement all the support needed for it because there are too few
users on Alpha to justify the effort.  But if we could score an
implementation of ProfileMe mode with minimal effort on the back of an
AMD implementation that would make us happy.

Cheers
Michael.
