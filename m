Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932946Ab1AMMZL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 07:25:11 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:58998 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756629Ab1AMMZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 07:25:07 -0500
Date: Thu, 13 Jan 2011 13:25:05 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        sparclinux@vger.kernel.org
Subject: Re: sparc boot failure due to perf init
Message-ID: <20110113122505.GA27522@merkur.ravnborg.org>
References: <1294431832.2016.457.camel@laptop> <1294432055.2016.458.camel@laptop> <20110107203119.GA30408@merkur.ravnborg.org> <20110109.153745.35032992.davem@davemloft.net> <1294916129.19601.88.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294916129.19601.88.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  }
> >  
> > -arch_initcall(pcr_arch_init);
> > +early_initcall(pcr_arch_init);
> 
> 
> I just realized, doesn't this make bootability depend on link order?
Yes.

> Since both the pmu init and its dependencies are now early_initcall()
> how do we guarantee pcr_arch_init() and cpu_type_probe() are in fact
> called _before_ init_hw_perf_events()?

Today this is achieved by perf_event.o being located last
in the Makefile in arch/sparc/kernel/

It deserves a comment..

	Sam
