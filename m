Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab1HLSHz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 14:07:55 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:5780
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753806Ab1HLSHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 14:07:53 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zz936eK1432N98dKzz1202hzzz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LPTUCZ-02-EBZ-02
X-M-MSG: 
Date: Fri, 12 Aug 2011 20:07:47 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/7] perf, x86: Implement IBS interrupt handler
Message-ID: <20110812180747.GH11702@erda.amd.com>
References: <1311860812-28748-1-git-send-email-robert.richter@amd.com>
 <1311860812-28748-5-git-send-email-robert.richter@amd.com>
 <1312285408.1147.115.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1312285408.1147.115.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.08.11 07:43:28, Peter Zijlstra wrote:
> On Thu, 2011-07-28 at 15:46 +0200, Robert Richter wrote:
> > +       msr = hwc->config_base;
> > +       buf = buffer;
> > +       rdmsrl(msr++, *buf);
> > +       if (!(*buf++ & perf_ibs->valid_mask))
> > +               return 0;
> > +
> > +       perf_sample_data_init(&data, 0);
> > +       if (event->attr.sample_type & PERF_SAMPLE_RAW) {
> > +               for (i = 1; i < perf_ibs->reg_count; i++)
> > +                       rdmsrl(msr++, *buf++);
> > +               raw.size = sizeof(u32) + sizeof(u64) * perf_ibs->reg_count;
> > +               raw.data = buffer;
> > +               data.raw = &raw;
> > +       } 
> 
> OK, so this dumps a linear range of MSRs into the raw data buffer. The
> only 'problem' I have with that is that Fam12 will then also dump 103A
> IBS Control Register, which seems pointless.

I will implement a bit mask instead. We can then use
for_each_set_bit() etc.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

