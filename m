Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab0KIXxX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 18:53:23 -0500
Received: from smtp.outflux.net ([198.145.64.163]:54018 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978Ab0KIXxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 18:53:23 -0500
Date: Tue, 9 Nov 2010 15:53:14 -0800
From: Kees Cook <kees.cook@canonical.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Security] [PATCH v3 0/4] x86: clear XD_DISABLED flag on Intel
 to regain NX
Message-ID: <20101109235314.GD5876@outflux.net>
References: <20101109181157.GE5876@outflux.net>
 <20101109183142.4ebfa737@lxorguk.ukuu.org.uk>
 <20101109185604.GK5876@outflux.net>
 <20101109225000.1b90e720@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101109225000.1b90e720@lxorguk.ukuu.org.uk>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Tue, Nov 09, 2010 at 10:50:00PM +0000, Alan Cox wrote:
> On Tue, 9 Nov 2010 10:56:04 -0800
> Kees Cook <kees.cook@canonical.com> wrote:
> 
> > On Tue, Nov 09, 2010 at 06:31:42PM +0000, Alan Cox wrote:
> > > > In a review[1] of reported hardware being used by Ubuntu bug reporters,
> > > > almost 10% of systems had an incorrectly configured BIOS, leaving their
> > > > systems unable to use the NX features of their CPU.
> > > 
> > > Ouch
> > 
> > Yeah :(
> > 
> > > > This change will clear the MSR_IA32_MISC_ENABLE_XD_DISABLE bit so that NX
> > > > cannot be inappropriately controlled by the BIOS on Intel CPUs.  If, under
> > > > very strange hardware configurations, NX actually needs to be disabled,
> > > > "noexec=off" can be used to restore the prior behavior.
> > > 
> > > Have you done an audit of CPU errata to ensure that none of these cases
> > > are ones where the BIOS has disabled it to avoid an erratum. I'd hate to
> > > turn it on and find out the BIOS actually turned it off for good reason !
> > 
> > Where can I find those details?
> 
> In the errata manuals for each processor released by the relevant
> vendors. As they are aggregated into families and they have an index in
> the front it shouldn't take too long to check the ones your 10% scan
> found.

Only Intel has this problem (it's the only CPU that defines this MSR), so
that'll reduce it. But Google is of no help to me on this; where can I find
these documents?

> I'm not specifically aware of any but I do know for example that there
> are other CPU BIOS disablable features that some systems disable in the
> BIOS for good reason (an ancient example being the original Pentium
> REP MOVS optimisation on some steppings)

By definition there should be fewer errata CPUs than those than need their
BIOS ignored, so I still think this patch makes sense (especially since it
can trivially be worked around with the noexec=off boot option).

-Kees

-- 
Kees Cook
Ubuntu Security Team
