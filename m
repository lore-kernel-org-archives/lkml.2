Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab0GIIPY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 04:15:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:59381 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab0GIIPW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 04:15:22 -0400
Subject: Re: [RFC][PATCH 05/11] perf: register pmu implementations
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
In-Reply-To: <20100709030846.GN7771@brick.ozlabs.ibm.com>
References: <20100624142804.431553874@chello.nl>
	 <20100624143406.764162308@chello.nl>
	 <20100709030846.GN7771@brick.ozlabs.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 09 Jul 2010 10:14:45 +0200
Message-ID: <1278663285.1900.191.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-09 at 13:08 +1000, Paul Mackerras wrote:

> > -struct pmu *hw_perf_event_init(struct perf_event *event)
> > +static in sh_pmu_event_init(struct perf_event *event)
> 
> int?

Argh, I fixed that a few times, but the hunk keeps slipping into
different patches.. cured.

> >  {
> >  	int err = __hw_perf_event_init(event);
> 
> We need a switch on event->attr.type so we return -ENOENT if it's
> not PERF_TYPE_{HARDWARE,HW_CACHE,RAW}.  As it is we don't ever return
> -ENOENT, which might stop software and tracepoint events from working.

Aaah, indeed! That is why Matt's perf record broke, perf record defaults
to -e cycles which automagically falls back to a software timer, which
then doesn't work.

