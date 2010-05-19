Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711Ab0ESJbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 05:31:15 -0400
Received: from mail-va3.bigfish.com ([216.32.180.114]:47253 "EHLO
	mail182-va3-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752847Ab0ESJbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 05:31:13 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zz1432P98dN936eM62a3Lzz1202hzzz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-WSS-ID: 0L2NUFI-02-9FS-02
X-M-MSG: 
Date: Wed, 19 May 2010 11:31:00 +0200
From: Robert Richter <robert.richter@amd.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] perf: align raw sample data on 64-bit boundaries
Message-ID: <20100519093100.GL21799@erda.amd.com>
References: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
 <1271190201-25705-13-git-send-email-robert.richter@amd.com>
 <n2wbd4cb8901004190519m9c939c26wbe49701fdfd2379a@mail.gmail.com>
 <20100518151227.GJ21799@erda.amd.com>
 <20100519073908.GE5704@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100519073908.GE5704@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.05.10 03:39:10, Frederic Weisbecker wrote:

> > This changes the ABI and requires changes in the userland tools. For
> > tools/perf this is at a single location in event.c only. This could
> > also introduce some overhead on smaller architectures, but currently
> > this is only used on x86 or for transferring raw tracepoint
> > data.
> 
> 
> No this is used on any architectures that event have a minimal support for
> perf events.
> 
> I use tracepoint raw samples in sparc 64 for example (which has much more
> than the minimal support).

Isn't here the same alignment problem on archs there unsigned long is
64 bit? Also, most samples I found have a size of multiples of 8
bytes, so even on 32 bit archs there would be a padding of 4 bytes
somethere in the sample.

> I don't think we should do this. Ok it's true we've screwed up
> something there but breaking the ABI is going to make the things
> even worst I think.

I was not sure how hard an ABI breakage would be. I think the small
number of users of raw samples is manageable, but I understand if you
feel uncomfortable with it.

> I would feel better with a new PERF_SAMPLE_RAW_ALIGNED sample_type
> and schedule the deprecation of PERF_SAMPLE_RAW for later but keep
> it for some releases.

This could be an alternative. Though, it duplicates code paths and
introduces ugly sample type checks. Another alternative would be to
check the size value, if it is (n * sizeof(u64)) we could asume 64 bit
alignment. But maybe this makes things much worse.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

