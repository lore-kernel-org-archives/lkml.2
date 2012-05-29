Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab2E2RMi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 13:12:38 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:59559 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064Ab2E2RMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 13:12:37 -0400
Date: Tue, 29 May 2012 19:13:05 +0200
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        hpa <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: WARNING: at arch/x86/kernel/smpboot.c:310
 topology_sane.clone.1+0x6e/0x81()
Message-ID: <20120529171305.GK29157@aftab.osrc.amd.com>
References: <20120529135442.GE29157@aftab.osrc.amd.com>
 <1338303106.26856.92.camel@twins>
 <20120529152944.GA8263@alberich.amd.com>
 <1338310743.26856.141.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338310743.26856.141.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 06:59:03PM +0200, Peter Zijlstra wrote:
> On Tue, 2012-05-29 at 17:29 +0200, Andreas Herrmann wrote:
> 
> > I've also looked at this. core_siblings mask is broken with this patch.
> > And there is this new irritating warning ...
> 
> Hehe, you made this irritating hardware ;-) But fair enough.
> 
> > I second Boris' suggestion for a fix. But I think the check for
> > X86_FEATURE_AMD_DCM should go into topology_sane() which in theory
> > could check other things as well.
> 
> Unless you plan to go span cache (or even SMT siblings) over physical
> IDs I'd strongly argue against putting it in topology_sane().

Nah, the check goes in match_mc - we just talked it over with Andreas.

> As it stands I think we should discuss the definition for the generic
> topology bits (drivers/base/topology.c), because I think your
> Magny-Cours thing does the wrong thing here.

"wrong" is such a strong word :-) Please elaborate and I'll have a look.

> The core span in a phys_id is all nice and such, but what does it mean?

AFAICT, this is the physical package id to which the cores belong, i.e.
physical socket.

> IOW what would you do with it?

Shoot empty cans with it... :-)

Andreas?

> I would think the LLC range and the node-span are much more useful
> things to have. Once you have nodes the sysfs node topology takes
> over.

Yes, the LLC range should be the cores belonging to an internal node and
the node-span is the cores belonging to a physical socket. I think you
can compute anything else from those topo-wise.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
