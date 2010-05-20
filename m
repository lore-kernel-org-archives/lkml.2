Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab0ETPXF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 11:23:05 -0400
Received: from mail-va3.bigfish.com ([216.32.180.112]:38680 "EHLO
	mail56-va3-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751835Ab0ETPXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 11:23:03 -0400
X-SpamScore: -30
X-BigFish: VPS-30(zz1432P98dN936eM62a3Lzz1202hzz5eeePz32i2a8h65h)
X-Spam-TCS-SCL: 4:0
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-WSS-ID: 0L2Q5D7-01-AL5-02
X-M-MSG: 
Date: Thu, 20 May 2010 17:22:21 +0200
From: Robert Richter <robert.richter@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       David Miller <davem@davemloft.net>, Will Deacon <will.deacon@arm.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 1/7] perf: introduce raw_type attribute to specify the
 type of a raw sample
Message-ID: <20100520152221.GR21799@erda.amd.com>
References: <1274304024-6551-1-git-send-email-robert.richter@amd.com>
 <1274304024-6551-2-git-send-email-robert.richter@amd.com>
 <AANLkTiniEWKJIrbTSZQ0jBXps75WVQbvGSXVyUVttJ7P@mail.gmail.com>
 <1274347413.5605.13636.camel@twins>
 <AANLkTikWSOPpHsvJGht7c7QnwcOk-nMyBNhY-g6QpNzg@mail.gmail.com>
 <1274351859.5605.13961.camel@twins>
 <AANLkTimkCIw2va2qF9D6zIuMZoh5VdSdWAxeXRBXSDLD@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <AANLkTimkCIw2va2qF9D6zIuMZoh5VdSdWAxeXRBXSDLD@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.05.10 08:13:43, Stephane Eranian wrote:
> What's wrong with creating pseudo-events for IBS? We'd have to pick
> two unused event codes. That would have the advantage of making it
> explicit you're using IBS. I think we could still use the precise_ip field
> if people are only interested in the IP. They would use PERF_SAMPLE_RAW
> if they need more.

For some key events this is fine and useful. But, if this has to be
used to programm all IBS features, it will introduce too much
implementation and maintenance effort. What you get then will probably
of less interest since users/tools want to have the raw sample data
for further processing. But maybe we agree already in this point, if
there is a demand we should provide pseudo events for important or
offen used events.

> >> > The Ins-Exec will have to re-construct the actual event->count by adding
> >> > sample-period on each interrupt, as it seems we lack an actual counter
> >> > in hardware.
> >> >
> >> For what? counting mode?
> >
> > Yeah, events are supposed to count.
> >
> IBS is a sampling only feature. I suspect it would be okay to return 0 here
> or do as you said, count the number of IBS interrupts and multiply by the
> sampling period.

True, ibs can be used as an additional counter using the interrupt
only and dropping sampling data. I was already thinking of adding it
somehow to the list of available counters. But this is also later work
as its 64 bit extension.

> > Dunno, reconstruct sensible counters? Surely the software that uses IBS
> > does something useful with that data? What does libpfm do with the IBS
> > data?

Here are some use cases described:

 http://developer.amd.com/assets/AMD_IBS_paper_EN.pdf
 http://developer.amd.com/cpu/CodeAnalyst/assets/ISPASS2010_IBS_CA_abstract.pdf

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

