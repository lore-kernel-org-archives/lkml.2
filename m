Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972Ab1HSVOQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 17:14:16 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55450 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134Ab1HSVON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 17:14:13 -0400
Date: Fri, 19 Aug 2011 22:14:02 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH RFC] ARM: vexpress: Use assembler mnemonic for WFI in
 platform_do_lowpower.
Message-ID: <20110819211402.GB12654@gallagher>
References: <1313777004-4716-1-git-send-email-nbowler@elliptictech.com>
 <20110819181514.GA12654@gallagher>
 <20110819192638.GA21043@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110819192638.GA21043@elliptictech.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 03:26:38PM -0400, Nick Bowler wrote:
> On 2011-08-19 19:15 +0100, Jamie Iles wrote:
> > On Fri, Aug 19, 2011 at 02:03:24PM -0400, Nick Bowler wrote:
> [...]
> > > -		/*
> > > -		 * here's the WFI
> > > -		 */
> > > -		asm(".word	0xe320f003\n"
> > > +		asm("wfi\n"
> > >  		    :
> > >  		    :
> > >  		    : "memory", "cc");
> > 
> > There's a wfi() macro defined in arch/arm/include/asm/system.h that 
> > could be used here.
> 
> Indeed, thanks for pointing that out.
> 
> I'm a little wary, however: the wfi macro does not include the "cc"
> clobber that this code has currently, and I don't know what the
> implications of removing it are.  There appears to be no current
> users of the wfi macro.

As far as I can tell from the ARM ARM, the instruction shouldn't alter 
the condition flags so the cc clobber shouldn't be necessary.  I'm not 
sure that my reading of the ARM ARM should be considered authoritative 
though!

Jamie
