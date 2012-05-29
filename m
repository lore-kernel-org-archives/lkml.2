Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab2E2RZd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 13:25:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37272 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690Ab2E2RZc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 13:25:32 -0400
Message-ID: <1338312319.26856.159.camel@twins>
Subject: Re: WARNING: at arch/x86/kernel/smpboot.c:310
 topology_sane.clone.1+0x6e/0x81()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Borislav Petkov <bp@amd64.org>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        hpa <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 29 May 2012 19:25:19 +0200
In-Reply-To: <20120529171305.GK29157@aftab.osrc.amd.com>
References: <20120529135442.GE29157@aftab.osrc.amd.com>
	 <1338303106.26856.92.camel@twins> <20120529152944.GA8263@alberich.amd.com>
	 <1338310743.26856.141.camel@twins>
	 <20120529171305.GK29157@aftab.osrc.amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-29 at 19:13 +0200, Borislav Petkov wrote:
> 
> > As it stands I think we should discuss the definition for the generic
> > topology bits (drivers/base/topology.c), because I think your
> > Magny-Cours thing does the wrong thing here.
> 
> "wrong" is such a strong word :-) Please elaborate and I'll have a look.

Right, so I meant LLC is the useful mask, and in my mind LLC is what
makes a multi-core, without shared cache its just SMP. So core_siblings
to me would mean LLC sharing cores.

But its all very subjective I guess, but using strong words gets the
discussion going better ;-)

> > The core span in a phys_id is all nice and such, but what does it mean?
> 
> AFAICT, this is the physical package id to which the cores belong, i.e.
> physical socket.
> 
> > IOW what would you do with it?
> 
> Shoot empty cans with it... :-) 

Right, I actually came up with proper use-case, physical hotplug :-)

Its not immediately obvious the sysfs topo bits have the llc mask, which
is the more 'useful' one IMO.

Another funny case I don't see represented well is where there's
multiple sockets to a node -- I know this is like ancient tech and
unlikely in these days of multi-node sockets, but still ;-)

I guess what I'm asking is what is the purpose of the sys topo bits?
