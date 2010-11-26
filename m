Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751046Ab0KZLYI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 06:24:08 -0500
Received: from canuck.infradead.org ([134.117.69.58]:47135 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab0KZLYH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 06:24:07 -0500
Subject: Re: [RFC PATCH 2/3 v2] perf: Implement Nehalem uncore pmu
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>
Cc: Lin Ming <lin@ming.vg>, Lin Ming <ming.m.lin@intel.com>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <AANLkTimN6_v6VibsNU70kV_QUnF4Fj0=M=Akp8aASE-3@mail.gmail.com>
References: <1290340877.2245.124.camel@localhost>
	 <AANLkTikt8AkZjNahrzTStJ5qM0D4Z+H_7snZBgsABm24@mail.gmail.com>
	 <AANLkTimzEDXzF=hMzmNCvsPok1kqxd0vjNKuYur_+J5L@mail.gmail.com>
	 <AANLkTimN6_v6VibsNU70kV_QUnF4Fj0=M=Akp8aASE-3@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 26 Nov 2010 12:24:12 +0100
Message-ID: <1290770652.2145.128.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-26 at 09:18 +0100, Stephane Eranian wrote:

> In the perf_event model, given that any one of the 4 cores can be used
> to program uncore events, you have no choice but to broadcast to all
> 4 cores. Each has to demultiplex and figure out which of its counters
> have overflowed.

Not really, you can redirect all these events to the first online cpu of
the node.

You can re-write event->cpu in pmu::event_init(), and register cpu
hotplug notifiers to migrate the state around.


