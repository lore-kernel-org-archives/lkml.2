Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab1GFQyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 12:54:23 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:26619 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab1GFQyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 12:54:22 -0400
X-SpamScore: -8
X-BigFish: VPS-8(zz1432N98dKzz1202hzzz32i668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LNX8AD-01-0CG-02
X-M-MSG: 
Date: Wed, 6 Jul 2011 18:53:57 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH] perf: Attaching an event to a specific PMU
Message-ID: <20110706165357.GG4590@erda.amd.com>
References: <20110703150430.GV4590@erda.amd.com>
 <1309716271.3282.6.camel@twins>
 <20110704175927.GZ4590@erda.amd.com>
 <1309855905.3282.42.camel@twins>
 <20110705091252.GA5725@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110705091252.GA5725@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.07.11 05:12:52, Ingo Molnar wrote:
> 
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > > Overall, my approach improves the perf design. It adds a better 
> > > and more intuitve access to perf from user space with clear and 
> > > common methods and interfaces. Please let me know the concerns 
> > > you have.
> > 
> > Its redundant, this interface ship has sailed, its not going to 
> > happen.
> 
> Even if we had the choice, i don't see how a /dev based enumeration 
> of PMUs is in any way better than a topologically attached set of 
> PMUs in /sys.
> 
> This kind of structure is nice in principle:
> 
>  # ls -l /dev/pmu/
>  total 0
>  crw-rw---- 1 root root 254, 5 Jul  8  2011 breakpoint
>  crw-rw---- 1 root root 254, 4 Jul  8  2011 cpu
>  crw-rw---- 1 root root 254, 6 Jul  8  2011 proto
>  crw-rw---- 1 root root 254, 1 Jul  8  2011 software
>  crw-rw---- 1 root root 254, 2 Jul  8  2011 tracepoint
> 
> But it should be done in /sys/.

I have to learn yet why /dev is bad and /sys is good...

The system topology is always in /sys, also for device nodes. But we
can't get a device file descriptor from /sys. I doubt /sys is capable
to handle a device use count (need to be checked). We actually must
grab the pmu while attaching events to it. And, user space
implementation is must easier with /dev (see code in my previous
mail).

My patch also includes code that creates a device class. It is also
visible in /sys/class/pmu/*.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

