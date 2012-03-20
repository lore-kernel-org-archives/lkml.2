Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759211Ab2CTPeF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 11:34:05 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46659 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab2CTPeC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 11:34:02 -0400
Message-ID: <1332257610.18960.430.camel@twins>
Subject: Re: bisected: 'perf top' causing soft lockups under Xen
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Steven Noonan <steven@uplinklabs.net>, Ben Guthro <ben@guthro.net>,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Date: Tue, 20 Mar 2012 16:33:30 +0100
In-Reply-To: <20120320152354.GB29135@phenom.dumpdata.com>
References: <CAKbGBLgVyWC3iuu8n+aQ8UhziSPnbpHVNGtQ=9m-PzvVA1kzdg@mail.gmail.com>
	 <1328894901.25989.20.camel@laptop>
	 <20120210190412.GB12975@phenom.dumpdata.com>
	 <CAOvdn6WcdrLHOPJc0Hv53+0trEFnU=RQJL5+xUMhAO3C3HWqbw@mail.gmail.com>
	 <20120212205016.GA2794@asmodeus> <20120215085737.GA13722@asmodeus>
	 <1329297944.2293.36.camel@twins>
	 <20120215161741.GC4093@phenom.dumpdata.com>
	 <20120320152354.GB29135@phenom.dumpdata.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-20 at 11:23 -0400, Konrad Rzeszutek Wilk wrote:

> But in the meantime, are there any good docs to look over to get a good idea
> of how the perf code works?

Nope.. I don't think anybody bothered to write it down, and if they did
keep it up to date.

Best option is to just ask specific questions, either via email or irc.

But in particular the self-ipi stuff is contained in kernel/irq_work.c.
Its a lock-less list of work-items to be ran from irq-context on the cpu
that queues them. Typical usage would be from NMI context, although you
could equally well use it from any other context.
