Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758347Ab2I1O5G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 10:57:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38540 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758306Ab2I1O5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 10:57:04 -0400
Date: Fri, 28 Sep 2012 16:57:03 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 18/31] perf, core: Add a concept of a weightened sample
Message-ID: <20120928145703.GR16230@one.firstfloor.org>
References: <1348806696-31170-1-git-send-email-andi@firstfloor.org> <1348806696-31170-19-git-send-email-andi@firstfloor.org> <CABPqkBQPVbobTgaV97E0qvOcfWnK8jMmoyp6NEuMn2+WHZ97HQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQPVbobTgaV97E0qvOcfWnK8jMmoyp6NEuMn2+WHZ97HQ@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I came to the conclusion that yes we need something like a weight or cost
> as a generic way of reporting that in some modes the period is not really
> the right measure to evaluate the "cost" of an event.

I'm not fully sure if you're for or against it. I think
the patch is mostly orthogonal to what you're proposing

My main target is the TSX abort cost, the memory latencies 
I just added as a bonus.

> 
> I was testing my PEBS Load Latency patch this week, I came to that
> conclusion. The way perf report sorts samples based on aggregated
> periods per IP does not work for PEBS Load Latency (and possibly other
> modes). The sorting needs to be based on some cost that may be distinct
> from the period. By default, it would be the period, but for PEBS LL that
> would be the latency of the load at a specific IP. That would more reflect
> was is going on.


I originally folded the weight into nr_events, but in the end it turned
out it's fairly useful to expose both explicitely as sort keys.

In some cases you want the average weight, in others the total weight
(SUM(weight) * nr_events). I haven't tried to mess with the period
so far.

-Andi
