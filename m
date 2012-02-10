Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759486Ab2BJRYv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 12:24:51 -0500
Received: from casper.infradead.org ([85.118.1.10]:33411 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758253Ab2BJRYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 12:24:49 -0500
Subject: Re: bisected: 'perf top' causing soft lockups under Xen
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Steven Noonan <steven@uplinklabs.net>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <20120210161253.GA11690@phenom.dumpdata.com>
References: <CAKbGBLgVyWC3iuu8n+aQ8UhziSPnbpHVNGtQ=9m-PzvVA1kzdg@mail.gmail.com>
	 <20120210161253.GA11690@phenom.dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Feb 2012 18:24:29 +0100
Message-ID: <1328894669.25989.18.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-10 at 11:12 -0500, Konrad Rzeszutek Wilk wrote:
> Hm, during bootup what does perf say about the CPU availability? Is
> it that it can only do perf via NMI's? 

We used to pass down if the event came from NMI context or not in order
to avoid doing certain things that were not NMI-safe, like wakeups.

That patch changed the code so that it always assumed the worst case
(NMI) and thus avoids doing such things.

All non-NMI-safe operations are pushed out to IRQ context through
kernel/irq_work.c. If there's no particular platform support for that,
it falls back to doing that work from the timer tick.

Now that all _should_ just work but clearly there's a problem there.

I haven't tried making sense of the traces yet..

