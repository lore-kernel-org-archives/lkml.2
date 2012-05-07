Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283Ab2EGPw3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 11:52:29 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:55045 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757249Ab2EGPw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 11:52:26 -0400
X-SpamScore: -13
X-BigFish: VPS-13(zz936eK1432N98dK4015Izz1202hzzz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M3NTF7-02-5VT-02
X-M-MSG: 
Date: Mon, 7 May 2012 17:52:16 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/7] perf/x86-ibs: Add support for IBS pseudo events
Message-ID: <20120507155216.GI18810@erda.amd.com>
References: <1335983192-23731-1-git-send-email-robert.richter@amd.com>
 <1335983192-23731-5-git-send-email-robert.richter@amd.com>
 <CABPqkBQQcENVAdZZ3PzEbwNNRFh+r9yax10s37cAe7uuOwBPOw@mail.gmail.com>
 <1336404557.27020.69.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1336404557.27020.69.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.05.12 17:29:17, Peter Zijlstra wrote:
> On Mon, 2012-05-07 at 17:21 +0200, Stephane Eranian wrote:
> > There is something I don't quite understand with those pseudo-events.
> > Is it the case that by construction, it means you can only measure
> > on pseudo-event at a time? Supposed I want to look at cache-misses.
> > For each miss, I'd like to know where it missed, any TLB impacts. All
> > of that in one run with no multiplexing. Can I do this with your
> > pseudo-events?
> > 
> Not from how I read the patch, a pseudo event will count as a full event
> and since the IBS things only have a single thing its full.
> 
> If you want multiple of these you'd have to get the raw stream and demux
> in userspace.

As said in my previous mail, this is a drawback. And as with
precise-rip it is better to implement this in userland.

The question here is how to implement it. You need the event option
string (-e) not only to setup the syscall but also for userspace
post-processing. Any hint for something similar already done in perf?

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

