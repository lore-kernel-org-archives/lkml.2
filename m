Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877Ab2EGPoo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 11:44:44 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:31008 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754541Ab2EGPon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 11:44:43 -0400
X-SpamScore: -12
X-BigFish: VPS-12(zz936eK1432N98dKzz1202hzzz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M3NT2E-01-2IR-02
X-M-MSG: 
Date: Mon, 7 May 2012 17:44:12 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/7] perf/x86-ibs: Add support for IBS pseudo events
Message-ID: <20120507154412.GH18810@erda.amd.com>
References: <1335983192-23731-1-git-send-email-robert.richter@amd.com>
 <1335983192-23731-5-git-send-email-robert.richter@amd.com>
 <1336395782.27020.37.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1336395782.27020.37.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.05.12 15:03:02, Peter Zijlstra wrote:
> On Wed, 2012-05-02 at 20:26 +0200, Robert Richter wrote:
> > +enum ibs_filter_type {
> > +       IBS_NO_FILTER           = 0,
> > +       IBS_MATCH_FILTER        = 1,
> > +       IBS_ANY_SET_FILTER      = 2,
> > +       IBS_PSEUDO_EVENT        = 0x0F,
> > +};
> 
> I don't get how those pseudo events work, AFAIKT IBS_PSEUDO_EVENT causes
> one to loose all events since it does have a filter set but fails the
> filter and thus we skip the call to perf_event_overflow().

You periodically (fix clk cycles or number of micro-ops) trigger IBS
samples and afterwards analyses the samples for certain filter rules
(see rule description in pmu-ibs.c).

> Furthermore, I think this filter stuff should accumulate the period so
> that PERF_SAMPLE_PERIOD still works correctly and reflects the number of
> counts since the last sample.

Yes, simply dropping the sample is not enough. Have to check if the
period is correctly maintained.

> Also, what's the point of filtering in-kernel as opposed to doing all
> this in userspace? Is the amount of data 'saved' significant enough?

In-kernel filtering has drawbacks esp. if you want to handle multiple
pseudo-events and also when post-processing a perf.data file. But for
a proof-of-concept and a demonstration it was the easiest
implementation since there is a lack of userland filtering. I guess I
will look at how to implement this.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

