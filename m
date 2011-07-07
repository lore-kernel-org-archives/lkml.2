Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab1GGJVN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 05:21:13 -0400
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:18762
	"EHLO DB3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753355Ab1GGJVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 05:21:09 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zz936eK1432N98dKzz1202hzzz32i668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LNYHZ3-02-A4E-02
X-M-MSG: 
Date: Thu, 7 Jul 2011 11:21:02 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH] perf: Attaching an event to a specific PMU
Message-ID: <20110707092102.GI4590@erda.amd.com>
References: <20110703150430.GV4590@erda.amd.com>
 <1309716271.3282.6.camel@twins>
 <20110704175927.GZ4590@erda.amd.com>
 <1309855905.3282.42.camel@twins>
 <20110705091252.GA5725@elte.hu>
 <20110706165357.GG4590@erda.amd.com>
 <1309972368.3282.317.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1309972368.3282.317.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.07.11 13:12:48, Peter Zijlstra wrote:
> On Wed, 2011-07-06 at 18:53 +0200, Robert Richter wrote:

> > The system topology is always in /sys, also for device nodes. But we
> > can't get a device file descriptor from /sys. I doubt /sys is capable
> > to handle a device use count (need to be checked). We actually must
> > grab the pmu while attaching events to it. And, user space
> > implementation is must easier with /dev (see code in my previous
> > mail).
> 
> Well you must not per-se, from a user's perspective there isn't much of
> a difference between if the sys_perf_event_open() fails or if the
> initial file open fails, in both cases he's not getting an event.

It is not that I want to create event handles with open. For this
there is the syscall. I use open() to create a unique reference to a
pmu in userspace. No more, and /dev is the right thing to do this.

> perf stat -e IBS:fetches will always have a fail against rmmod, rmmod
> could complete before we try to open the file (assuming IBS is a
> module).
> 
> > 
> > My patch also includes code that creates a device class. It is also
> > visible in /sys/class/pmu/*.
> 
> So not only are you providing a duplicate of existing interfaces, you're
> actually duplicating information inside sysfs as well.

This is not duplication. /sys provides information about system
hierarchy, /dev is for controlling devices. Thus, every device node is
visible in /sys as it is part of the system.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

