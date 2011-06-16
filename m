Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297Ab1FPP0K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 11:26:10 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:54358 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905Ab1FPP0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 11:26:06 -0400
X-SpamScore: -8
X-BigFish: VPS-8(zz1432N98dKzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LMW2UL-02-AZU-02
X-M-MSG: 
Date: Thu, 16 Jun 2011 17:25:31 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>
Subject: Re: [PATCH] oprofile, x86: Fix race in nmi handler while starting
Message-ID: <20110616152531.GR20052@erda.amd.com>
References: <1307465249-20055-1-git-send-email-robert.richter@amd.com>
 <20110609071854.GE20544@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110609071854.GE20544@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09.06.11 03:18:54, Ingo Molnar wrote:
> 
> * Robert Richter <robert.richter@amd.com> wrote:
> 
> > In some rare cases, nmis are generated immediately after the nmi 
> > handler of the cpu was started. This causes the counter not to be 
> > enabled. Before enabling the nmi handlers we need to set variable 
> > ctr_running first and make sure its value is written to memory.
> > 
> > Also, the patch makes all existing barriers a memory barrier 
> > instead of a compiler barrier only.
> 
> Could we *PLEASE* just do the obvious and turn oprofile into a perf 
> user on x86 too, like ARM already does? Two years down the line and 
> there's zero progress in that area. We want to obsolete the Oprofile 
> PMU bits on x86, the infrastructure duplication causes non-trivial 
> problems like this one.

Ingo,

I would rather prefer to spend the effort to add full pmu support to
perf. AMD features missing are still IBS and nb performance counters
for family 15h. The oprofile kernel driver would become obsolete at
all with a new daemon using the perf syscall interface. So why
spending more time with porting this legacy driver to perf in the
kernel? It will be also hard to implement identical behaviour which
may raise concerns about backward compatibility of the kernel driver.

I admit, we have had a lot of bug fixes for oprofile in the past, but
most of them are part of maintaining existing code which we have to do
for distros anyway. There is almost no or only limited feature
development for oprofile now.

Hope this makes sense.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

