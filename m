Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab2GXLE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 07:04:59 -0400
Received: from osrc3.amd.com ([217.9.48.20]:57998 "EHLO mail.x86-64.org"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753157Ab2GXLE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 07:04:58 -0400
Date: Tue, 24 Jul 2012 13:04:53 +0200
From: Borislav Petkov <bp@amd64.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andre Przywara <andre.przywara@amd.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 2/2] cpu: intel, amd: mask cleared cpuid features
Message-ID: <20120724110453.GA24893@aftab.osrc.amd.com>
References: <73e09fb43e37de851acda10dc64bc495a5b68357.1342801662.git.vdavydov@parallels.com>
 <dd185bfa60b6478e7eb1bce455c9d082ec884abe.1342801662.git.vdavydov@parallels.com>
 <20120721103715.GA3632@aftab.osrc.amd.com>
 <500E4960.8040307@parallels.com>
 <500E5951.5020900@amd.com>
 <20120724095031.GA24393@aftab.osrc.amd.com>
 <20120724113204.7f48efe6@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120724113204.7f48efe6@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 11:32:04AM +0100, Alan Cox wrote:
> > So actually, making it straightforward to disable CPUID feature bits
> > just for every whim is the bug.
> 
> Sometimes its needed to make stuff work. Expecting user space to go
> digging in odd places

Nah, not odd places. Simply doing "wrmsr... " as root would suffice.

> isn't good either but exposing *both* true/apparent cpuid bits might
> not be a bad idea.

I'm fine with the "might not be a bad idea" thing. I'm saying that it
seems like a bad idea in certain cases...

> > I'd like to see a real valid reason why someone would even think that.
> > Except virtualization folks who are crazy anyway, so that doesn't count :).
> 
> Which is a very large part of the x86 market. So they most definitely do
> count. Virtualisation is somewhat different though. There you are trying
> to define a subset of the features that all the systems in your
> environment have so you can do migrations. Virtualisation you have rather
> more different control of the cpuid and msrs anyway.

Right and best it would be if *only* virtualization had access to those
MSRs and CPUID bits. IOW, you #GP when accessing them in the normal case
and access is granted when in VMRUN context.

> > Majority of users is majority of users no matter how you look at it!
> 
> That's not a good argument. The majority of users don't have SCSI,
> certain processors and so on ...

or coffee machines ... :-)

> > Right, and how is giving the user a heavy, well-oiled AK-47 to do that,
> > user-friendly?
> 
> It's a point and click interface

Or rather, aim and squeeze :-)

> > And this is exactly what I'm questioning: the usability, or rather, the
> > mis-usability of such a feature.
> 
> What goes with that is "so how do you do it otherwise".

Not much more harder using msr-tools and easily scriptable. See above.

> Distros can certainly add patches for such features if needed but that
> just makes it even more fun to debug.

That's easy: the first question we ask from the bug reporter is (and you
do that too, btw - I've seen you dozens of times :-)) "can you reproduce
it with mainline"?

> Does "bind mount your own cpuid file" cover this ?

Well, AFAICU, the writes to the MSRs are globally visible. If you're
asking whether through bind-mounting your own cpuid file we're making
the process of toggling CPUID bits more involved versus using simply
kernel command line options then this is probably a step in the right
direction IMHO, BUT (!)...

... there's still a software-only solution needed for CPUID leafs which
cannot be toggled through MSR writes simply because there are no such
MSRs.

The solution to that situation could cover all issues without touching
the kernel.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
