Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249Ab0LALqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 06:46:39 -0500
Received: from fep15.mx.upcmail.net ([62.179.121.35]:52730 "EHLO
	fep15.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab0LALqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 06:46:38 -0500
X-SourceIP: 80.56.199.130
Subject: Re: [BUG(?)] perf_events: combining multiple tracepoint events
 into a group produces no counts on member events
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <4CF59E20.1040301@linux.vnet.ibm.com>
References: <4CF59E20.1040301@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Dec 2010 12:46:30 +0100
Message-ID: <1291203990.4023.16.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=JvXQbuMnWGQeb488dJ7w43Du7THgE+O7ieb9U20/rjk= c=1 sm=0 a=C_GBFuhjOzUA:10 a=IkcTkHD0fZMA:10 a=D19gQVrFAAAA:8 a=bbqQhKXX7VhOliRnHcgA:9 a=oV1sDWLOwBo5TrbPg-u_uD0fTyAA:4 a=QEXdDO2ut3YA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-30 at 17:00 -0800, Corey Ashford wrote:
> Hi,
> 
> I'm not sure that what I'm seeing is a bug, or was something intentional.
> 
> If I place multiple tracepoint events into a group and measure counts of 
> these events on a process, I get no counts for the tracepoint events 
> other than the group leader.
> 
> Is this expected behavior?
> 
> It's not clear to me why this should be the case; grouping shouldn't 
> have any ill effects on tracepoint events, from my understanding.
> 
> I noticed this because my private version of the perf tool has the event 
> group patch https://lkml.org/lkml/2010/11/24/584 as well as the patch 
> which fixes the parsing of multiple tracepoint events in the same -e 
> switch: https://lkml.org/lkml/2010/11/30/460
> 
> When I dig into the code a bit, I find that each event opens 
> successfully, so that's not the problem.  If I disable the grouping, 
> then I get counts for all of the tracepoint events.

Hrm,.. definitely not expected. I'll try and look into it, but I'm a bit
over-committed atm.

Also, I've started a rewrite of the whole tracepoint <-> perf
interaction:

  http://lkml.org/lkml/2010/11/23/147

Could you see if that cures your problem?

Another thing to test, does the same hold true for regular software
events? tracepoints and software events share a lot of infrastructure.


