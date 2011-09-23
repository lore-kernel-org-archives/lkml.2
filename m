Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409Ab1IWIpS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 04:45:18 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:17271 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751998Ab1IWIpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 04:45:12 -0400
X-SpamScore: -8
X-BigFish: VPS-8(zz1432N98dKzz1202hzz8275bhz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LRYWAW-02-1BS-02
X-M-MSG: 
Date: Fri, 23 Sep 2011 10:44:57 +0200
From: Robert Richter <robert.richter@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [V3][PATCH 4/7] perf, x86: Implement IBS interrupt handler
Message-ID: <20110923084457.GM6063@erda.amd.com>
References: <1316597423-25723-1-git-send-email-robert.richter@amd.com>
 <1316597423-25723-5-git-send-email-robert.richter@amd.com>
 <m2litgjleh.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <m2litgjleh.fsf@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.09.11 17:51:34, Andi Kleen wrote:
> Robert Richter <robert.richter@amd.com> writes:
> >  
> > +static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
> > +{
> > +	struct perf_event *event = NULL;
> > +	struct hw_perf_event *hwc = &event->hw;
> > +	struct perf_sample_data data;
> > +	struct perf_raw_record raw;
> > +	struct pt_regs regs;
> > +	struct perf_ibs_data ibs_data;
> > +	int offset, size;
> > +	unsigned int msr;
> > +	u64 *buf;
> > +
> > +	msr = hwc->config_base;
> > +	buf = ibs_data.regs;
> > +	rdmsrl(msr, *buf);
> > +	if (!(*buf++ & perf_ibs->valid_mask))
> > +		return 0;
> 
> No check if the NMI is really caused by IBS? Very nasty.
> This will not interoperate well with other NMIs.

This is the check. If the valid bit is set in the config base msr,
then the nmi was caused by ibs. The function returns the number of
handled counters.

There is some more logic in the next patch that prevents reading the
msr if ibs is disabled.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

