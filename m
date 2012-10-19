Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758739Ab2JSOIq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 10:08:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:49433 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548Ab2JSOIo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 10:08:44 -0400
Message-ID: <1350655669.2768.14.camel@twins>
Subject: Re: perf: p6 PMU working by accident, should we fix it and KNC?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, eranian@gmail.com,
        "Meadows, Lawrence F" <lawrence.f.meadows@intel.com>
Date: Fri, 19 Oct 2012 16:07:49 +0200
In-Reply-To: <alpine.DEB.2.02.1210171125040.23371@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.02.1210171125040.23371@vincent-weaver-1.um.maine.edu>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-17 at 11:35 -0400, Vince Weaver wrote:
> 
> This is by accident; it looks like the code does 
>    val |= ARCH_PERFMON_EVENTSEL_ENABLE;
> in p6_pmu_disable_event() so that events are never truly disabled
> (is this a bug?  should it be &=~ instead?).  

I think that's on purpose.. from what I can remember p6 only has a
single EN bit (on PMC0) that acts for both counters. So what I did was
treat that as a global enable/disable (which it is) and did the local
enable/disable by using the NOP events.

There really might be bugs in there, its not like I use this class of
hardware very frequently (nor do anybody much it seems).


