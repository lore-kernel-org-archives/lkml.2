Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881Ab2JLGm0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 02:42:26 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52573 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755854Ab2JLGmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 02:42:23 -0400
X-Sasl-enc: JZPG+GNzoF8ktMixLAoHBbcG0u6rok+A/6PdI7nBXdJU 1350024142
Date: Fri, 12 Oct 2012 15:42:20 +0900
From: Greg KH <greg@kroah.com>
To: Willy Tarreau <w@1wt.eu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Romain Francoise <romain@orebokech.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Linux 2.6.32.60
Message-ID: <20121012064220.GA24957@kroah.com>
References: <20121009094453.GA4289@1wt.eu>
 <87y5jeqv6b.fsf@silenus.orebokech.com>
 <20121011062916.GG8938@1wt.eu>
 <20121011105804.GB28546@kroah.com>
 <20121011113106.GR8938@1wt.eu>
 <50775210.4060007@zytor.com>
 <20121012063848.GD12041@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121012063848.GD12041@1wt.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 08:38:48AM +0200, Willy Tarreau wrote:
> On Fri, Oct 12, 2012 at 07:11:12AM +0800, H. Peter Anvin wrote:
> > On 10/11/2012 07:31 PM, Willy Tarreau wrote:
> > > On Thu, Oct 11, 2012 at 07:58:04PM +0900, Greg KH wrote:
> > >> On Thu, Oct 11, 2012 at 08:29:16AM +0200, Willy Tarreau wrote:
> > >>> If you think these patches constitute a regression, I can revert them.
> > >>> However I'd like convincing arguments since they're here to help address
> > >>> a real issue.
> > >>
> > >> If I missed these when doing the random number generation backport for
> > >> 3.0, and I should add them there as well, please let me know.
> > > 
> > > At least I think they should not be in 2.6.32 without being in 3.0.
> > > Probably that Peter's opinion will help us decide whether they should
> > > go into 3.0 or 2.6.32 should revert them.
> > > 
> > 
> > I would strongly argue for at least one of the RDRAND-enabling versions
> > being in all supported kernels; the second (with Ted Ts'o's changes) is
> > better, but touches a *lot* of subsystems; the plain one is
> > self-contained but only helps RDRAND-enabled hardware.
> > 
> > Without these patches the random subsystem has a critical security flaw,
> > which puts it into the scope for stable.
> 
> That's clearly what I understood, thanks Peter for confirming ! So I won't
> revert the patches unless a regression is reported in which case we'll
> prefer to fix it.
> 
> Greg, I think it would be better to get them into 3.0 too. The ones I used
> were (prefixed with 'X' if they are already in 3.0) :
>    24da9c26 x86, cpu: Add CPU flags for F16C and RDRND
>    7ccafc5f x86, cpufeature: Update CPU feature RDRND to RDRAND
>  X 63d77173 random: Add support for architectural random hooks
>  X bd29e568 fix typo/thinko in get_random_bytes()
>    628c6246 x86, random: Architectural inlines to get random integers with RDRAND
>    49d859d7 x86, random: Verify RDRAND functionality and allow it to be disabled
>  X cf833d0b random: Use arch_get_random_int instead of cycle counter if avail
>  X 3e88bdff random: Use arch-specific RNG to initialize the entropy store
>  X 2dac8e54 random: Adjust the number of loops when initializing
> 
> So in the end it seems you only need to add 24da9c26, 7ccafc5f, 628c6246, and
> 49d859d7 to get them all.
> 
> There should be no problem to backport them since initially I could pick most
> of them directly from 3.2, though it was easier to pick all of them from .34
> in the end.

Thanks, I'll dig them out for the next 3.0 release after this one.

greg k-h
