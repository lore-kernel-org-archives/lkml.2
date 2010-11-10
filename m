Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789Ab0KJSPS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:15:18 -0500
Received: from smtp.outflux.net ([198.145.64.163]:36593 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755628Ab0KJSPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:15:17 -0500
Date: Wed, 10 Nov 2010 10:15:03 -0800
From: Kees Cook <kees.cook@canonical.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] x86: clear XD_DISABLED flag on Intel to regain NX
Message-ID: <20101110181503.GS5876@outflux.net>
References: <20101109181157.GE5876@outflux.net>
 <20101109181501.GG5876@outflux.net>
 <87hbfpp390.fsf@basil.nowhere.org>
 <20101110164708.GN5876@outflux.net>
 <20101110174210.GA9011@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101110174210.GA9011@basil.fritz.box>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 06:42:10PM +0100, Andi Kleen wrote:
> > Right, which is why in this code it validates the CPU brand and its
> > family and model to make sure it's safe to read this MSR. The logic
> > is identical to the code in early_init_intel() that also accesses
> > MSR_IA32_MISC_ENABLE. I reviewed the CPU documentation and it seemed
> > to support that MSR_IA32_MISC_ENABLE would be available under those
> > conditions. That said, I only had a limited number of systems available
> > to test it on. If there are adjustments to be made, we can fix them.
> 
> If you can even find out. The system will die silently.
> 
> Usually the main culprits are simulators. VMs etc. Most do ignore unknown
> MSRs, but not all.

Well, that would be a bug in the simulator. :) Those bugs shouldn't cause a
non-trivial group of Linux users to lack NX.

> > > I would rather move this code later into the early init code (before the
> > > second mapping is set up, which is still in time). There the exception
> > > handlers are up and you could handle a #GP if it happens.
> > 
> > The problem is that the page tables are set up before early_init, and Peter
> > Anvin and I did not see a way to move the XD_DISABLE logic any later than
> > where I've put it. Though I should let Peter speak for himself here, as I'm
> > less familiar with that aspect of the code.
> 
> On x86-64 there are two kernel mappings: an early one and a final one.
> The final one is only set up in C code.
> 
> On 32bit there's only a single one, but it could be changed (e.g. 
> only add NX later)

I'm open to reviewing tested alternative patches. But right now, this
method is tested and works, and is based on several rounds of design
compromises/refinements.

-Kees

-- 
Kees Cook
Ubuntu Security Team
