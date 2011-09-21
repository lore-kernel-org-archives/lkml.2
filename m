Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab1IUIkB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 04:40:01 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:28432
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750955Ab1IUIj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 04:39:59 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zz936eK1432N98dKzz1202hzzz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LRV6QG-01-EU5-02
X-M-MSG: 
Date: Wed, 21 Sep 2011 10:39:51 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/7] perf, x86: Implement IBS interrupt handler
Message-ID: <20110921083951.GY6063@erda.amd.com>
References: <1315413376-769-1-git-send-email-robert.richter@amd.com>
 <1315413376-769-5-git-send-email-robert.richter@amd.com>
 <1316016805.5040.34.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1316016805.5040.34.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.09.11 12:13:25, Peter Zijlstra wrote:
> On Wed, 2011-09-07 at 18:36 +0200, Robert Richter wrote:
> > +       if (event->attr.sample_type & PERF_SAMPLE_RAW) {
> > +               ibs_data.caps = ibs_caps;
> > +               size = 1;
> > +               offset = 1;
> > +               do {
> > +                   rdmsrl(msr + offset, *buf++);
> > +                   size++;
> > +                   offset = find_next_bit(perf_ibs->offset_mask,
> > +                                          perf_ibs->offset_max,
> > +                                          offset + 1);
> > +               } while (offset < perf_ibs->offset_max);
> > +               raw.size = sizeof(u32) + sizeof(u64) * size;
> > +               raw.data = ibs_data.data;
> > +               data.raw = &raw;
> > +       } 
> 
> Another application of for_each_set_bit_continue() ?

Peter, I will make this a separate patch set to decouple from this
patch set. Will then update this code too. So in my next ibs patch set
I wont change this here.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

