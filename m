Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085Ab0KJQrP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 11:47:15 -0500
Received: from smtp.outflux.net ([198.145.64.163]:56668 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757028Ab0KJQrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 11:47:14 -0500
Date: Wed, 10 Nov 2010 08:47:08 -0800
From: Kees Cook <kees.cook@canonical.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] x86: clear XD_DISABLED flag on Intel to regain NX
Message-ID: <20101110164708.GN5876@outflux.net>
References: <20101109181157.GE5876@outflux.net>
 <20101109181501.GG5876@outflux.net>
 <87hbfpp390.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87hbfpp390.fsf@basil.nowhere.org>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Wed, Nov 10, 2010 at 05:11:55PM +0100, Andi Kleen wrote:
> Kees Cook <kees.cook@canonical.com> writes:
> > +
> > +verify_cpu_clear_xd:
> > +	movl	$MSR_IA32_MISC_ENABLE, %ecx
> > +	rdmsr
> > +	btrl	$2, %edx		# clear MSR_IA32_MISC_ENABLE_XD_DISABLE
> > +	jnc	verify_cpu_check	# only write MSR if bit was
> > changed
> 
> Strictly it's still a bit dangerous to read this MSR without knowing
> about the CPU for sure. If you guess wrong you'll die here.

Right, which is why in this code it validates the CPU brand and its
family and model to make sure it's safe to read this MSR. The logic
is identical to the code in early_init_intel() that also accesses
MSR_IA32_MISC_ENABLE. I reviewed the CPU documentation and it seemed
to support that MSR_IA32_MISC_ENABLE would be available under those
conditions. That said, I only had a limited number of systems available
to test it on. If there are adjustments to be made, we can fix them.

> I would rather move this code later into the early init code (before the
> second mapping is set up, which is still in time). There the exception
> handlers are up and you could handle a #GP if it happens.

The problem is that the page tables are set up before early_init, and Peter
Anvin and I did not see a way to move the XD_DISABLE logic any later than
where I've put it. Though I should let Peter speak for himself here, as I'm
less familiar with that aspect of the code.

-Kees

-- 
Kees Cook
Ubuntu Security Team
