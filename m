Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758739Ab2ILNEz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 09:04:55 -0400
Received: from [216.32.180.13] ([216.32.180.13]:15122 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758704Ab2ILNEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 09:04:51 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zz98dI936eI1432Izz1202h1d1ah1d2ahzz8275ch122ac1I17326ah8275dhz2dh668h839h944hd25hf0ah11b5h121eh1220h1288h12a5h12a9h12bdh1155h)
X-WSS-ID: 0MA8MWS-02-EES-02
X-M-MSG: 
Date: Wed, 12 Sep 2012 15:02:53 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] perf: Introduce function to report unsupported syscall
 attribute flags
Message-ID: <20120912130253.GY8285@erda.amd.com>
References: <1347447685-28513-1-git-send-email-robert.richter@amd.com>
 <1347448843.15764.3.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1347448843.15764.3.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.09.12 13:20:43, Peter Zijlstra wrote:
> On Wed, 2012-09-12 at 13:01 +0200, Robert Richter wrote:
> > +       if (notsup)
> > +               pr_warn("perf: unsupported attribute flags: %016llx\n", notsup); 
> 
> This is a dmesg DoS..

This could be avoided by introducing a cpuinfo like sysfs file for
each pmu:

 /sys/bus/event_source/devices/*/flags

Then, userspace should know how to correctly setup the syscall. All
supported attributes would be known to perf and messages would thrown
only if something goes unexpected wrong.

I suggested this already here:

 https://lkml.org/lkml/2012/8/3/214
 https://lkml.org/lkml/2012/9/6/472

> I'm also not sure dmesg is the right way.. could we not somehow change
> the attrs to provide better diagnostic?

I found this discussion without a solution for the problem:

 http://lwn.net/Articles/374794/

Other options could be pr_debug() or trace_printk()'s for debugging
purposes. Or an error report in sysfs:

 cat /sys/bus/event_source/devices/*/log

But the pmu type needs to be known for this.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

