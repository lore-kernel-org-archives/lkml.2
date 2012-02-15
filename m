Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166Ab2BOJ0Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 04:26:16 -0500
Received: from merlin.infradead.org ([205.233.59.134]:47138 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279Ab2BOJ0N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 04:26:13 -0500
Message-ID: <1329297944.2293.36.camel@twins>
Subject: Re: bisected: 'perf top' causing soft lockups under Xen
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Noonan <steven@uplinklabs.net>
Cc: Ben Guthro <ben@guthro.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Date: Wed, 15 Feb 2012 10:25:44 +0100
In-Reply-To: <20120215085737.GA13722@asmodeus>
References: <CAKbGBLgVyWC3iuu8n+aQ8UhziSPnbpHVNGtQ=9m-PzvVA1kzdg@mail.gmail.com>
	 <1328894901.25989.20.camel@laptop>
	 <20120210190412.GB12975@phenom.dumpdata.com>
	 <CAOvdn6WcdrLHOPJc0Hv53+0trEFnU=RQJL5+xUMhAO3C3HWqbw@mail.gmail.com>
	 <20120212205016.GA2794@asmodeus> <20120215085737.GA13722@asmodeus>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-15 at 00:57 -0800, Steven Noonan wrote:
> It seems to me that there are two options for fixing this, but I'm
> probably lacking the necessary context (or experience with Xen). Either:
> 
> - The patch provided by Ben needs to have additional work to specially
>   handle IRQ_WORK_VECTOR, since it seems to be a special case where
>   there's no event channel attached for it. Perhaps adding an event
>   channel for this is the fix? Seems high-overhead, but I lack a good
>   understanding of how interrupts are handled in Xen.

So that's a self-IPI, is Xen failing to implement this?

> or
> 
> - Perf needs to be "enlightened" about Xen and avoid sending an IPI in
>   the first place.

Uhm, no. If anything Xen should simply not implement
arch_irq_work_raise(). The callbacks are then ran from the timer
interrupt.
