Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab2E2RsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 13:48:17 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:53447 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754303Ab2E2RsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 13:48:15 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -12
X-BigFish: VPS-12(zz936eK1432N98dKzz1202hzzz2dh668h839h93fhd25hf0ah)
X-WSS-ID: 0M4SPG9-02-0N5-02
X-M-MSG: 
Date: Tue, 29 May 2012 19:48:04 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, hpa <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: WARNING: at arch/x86/kernel/smpboot.c:310
 topology_sane.clone.1+0x6e/0x81()
Message-ID: <20120529174804.GC8263@alberich.amd.com>
References: <20120529135442.GE29157@aftab.osrc.amd.com>
 <1338303106.26856.92.camel@twins>
 <20120529152944.GA8263@alberich.amd.com>
 <1338310743.26856.141.camel@twins>
 <20120529171305.GK29157@aftab.osrc.amd.com>
 <1338312319.26856.159.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1338312319.26856.159.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 07:25:19PM +0200, Peter Zijlstra wrote:
> On Tue, 2012-05-29 at 19:13 +0200, Borislav Petkov wrote:
> > 
> > > As it stands I think we should discuss the definition for the generic
> > > topology bits (drivers/base/topology.c), because I think your
> > > Magny-Cours thing does the wrong thing here.
> > 
> > "wrong" is such a strong word :-) Please elaborate and I'll have a look.
> 
> Right, so I meant LLC is the useful mask, and in my mind LLC is what
> makes a multi-core, without shared cache its just SMP. So core_siblings
> to me would mean LLC sharing cores.
> 
> But its all very subjective I guess, but using strong words gets the
> discussion going better ;-)
> 
> > > The core span in a phys_id is all nice and such, but what does it mean?
> > 
> > AFAICT, this is the physical package id to which the cores belong, i.e.
> > physical socket.
> > 
> > > IOW what would you do with it?
> > 
> > Shoot empty cans with it... :-) 
> 
> Right, I actually came up with proper use-case, physical hotplug :-)
> 
> Its not immediately obvious the sysfs topo bits have the llc mask, which
> is the more 'useful' one IMO.
> 
> Another funny case I don't see represented well is where there's
> multiple sockets to a node -- I know this is like ancient tech and
> unlikely in these days of multi-node sockets, but still ;-)
> 
> I guess what I'm asking is what is the purpose of the sys topo bits?

You mean the topology directory for each CPU in sysfs?

Where else do you find reliable/complete CPU topology information for
you system? (And yes I know that the info provided in this directory
is already incomplete for AMD multi-node CPUs.)

AFAIK hwloc relies on this information. (Together with cache topology
information in the cache sub-directory for each CPU.)

And if the question was why does it matter to know which cores belong
to which physical socket. What if you want to pin all your tasks to
both nodes of the same socket on AMD mult-node CPUs? Use
core_siblings/core_siblings_list provided in sysfs, use it as
parameter for a tool like taskset and you are done with it.


Andreas


