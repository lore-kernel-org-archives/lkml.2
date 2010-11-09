Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab0KIWvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 17:51:19 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41312 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754795Ab0KIWvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 17:51:18 -0500
Date: Tue, 9 Nov 2010 22:50:00 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kees Cook <kees.cook@canonical.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Security] [PATCH v3 0/4] x86: clear XD_DISABLED flag on Intel
 to regain NX
Message-ID: <20101109225000.1b90e720@lxorguk.ukuu.org.uk>
In-Reply-To: <20101109185604.GK5876@outflux.net>
References: <20101109181157.GE5876@outflux.net>
	<20101109183142.4ebfa737@lxorguk.ukuu.org.uk>
	<20101109185604.GK5876@outflux.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Nov 2010 10:56:04 -0800
Kees Cook <kees.cook@canonical.com> wrote:

> On Tue, Nov 09, 2010 at 06:31:42PM +0000, Alan Cox wrote:
> > > In a review[1] of reported hardware being used by Ubuntu bug reporters,
> > > almost 10% of systems had an incorrectly configured BIOS, leaving their
> > > systems unable to use the NX features of their CPU.
> > 
> > Ouch
> 
> Yeah :(
> 
> > > This change will clear the MSR_IA32_MISC_ENABLE_XD_DISABLE bit so that NX
> > > cannot be inappropriately controlled by the BIOS on Intel CPUs.  If, under
> > > very strange hardware configurations, NX actually needs to be disabled,
> > > "noexec=off" can be used to restore the prior behavior.
> > 
> > Have you done an audit of CPU errata to ensure that none of these cases
> > are ones where the BIOS has disabled it to avoid an erratum. I'd hate to
> > turn it on and find out the BIOS actually turned it off for good reason !
> 
> Where can I find those details?

In the errata manuals for each processor released by the relevant
vendors. As they are aggregated into families and they have an index in
the front it shouldn't take too long to check the ones your 10% scan
found.

I'm not specifically aware of any but I do know for example that there
are other CPU BIOS disablable features that some systems disable in the
BIOS for good reason (an ancient example being the original Pentium
REP MOVS optimisation on some steppings)

