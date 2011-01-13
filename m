Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932802Ab1AMMcz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 07:32:55 -0500
Received: from canuck.infradead.org ([134.117.69.58]:50852 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756629Ab1AMMcx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 07:32:53 -0500
Subject: Re: sparc boot failure due to perf init
From: Peter Zijlstra <peterz@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        sparclinux@vger.kernel.org
In-Reply-To: <20110113122505.GA27522@merkur.ravnborg.org>
References: <1294431832.2016.457.camel@laptop>
	 <1294432055.2016.458.camel@laptop>
	 <20110107203119.GA30408@merkur.ravnborg.org>
	 <20110109.153745.35032992.davem@davemloft.net>
	 <1294916129.19601.88.camel@laptop>
	 <20110113122505.GA27522@merkur.ravnborg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 13 Jan 2011 13:33:26 +0100
Message-ID: <1294922006.19601.106.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-13 at 13:25 +0100, Sam Ravnborg wrote:
> > >  }
> > >  
> > > -arch_initcall(pcr_arch_init);
> > > +early_initcall(pcr_arch_init);
> > 
> > 
> > I just realized, doesn't this make bootability depend on link order?
> Yes.
> 
> > Since both the pmu init and its dependencies are now early_initcall()
> > how do we guarantee pcr_arch_init() and cpu_type_probe() are in fact
> > called _before_ init_hw_perf_events()?
> 
> Today this is achieved by perf_event.o being located last
> in the Makefile in arch/sparc/kernel/
> 
> It deserves a comment..

Ah, right! and while make -j will compile concurrently, link order is
still maintained, and I guess until the linker decides to process its
input files in random order (or reverse order, or whatever) we're good.

Does something like GOLD which was supposed to be threaded or somesuch
still work as expected here?
