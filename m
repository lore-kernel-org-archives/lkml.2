Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab1HST0r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 15:26:47 -0400
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:35967 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755684Ab1HST0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 15:26:46 -0400
Date: Fri, 19 Aug 2011 15:26:38 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH RFC] ARM: vexpress: Use assembler mnemonic for WFI in
 platform_do_lowpower.
Message-ID: <20110819192638.GA21043@elliptictech.com>
References: <1313777004-4716-1-git-send-email-nbowler@elliptictech.com>
 <20110819181514.GA12654@gallagher>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110819181514.GA12654@gallagher>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-19 19:15 +0100, Jamie Iles wrote:
> On Fri, Aug 19, 2011 at 02:03:24PM -0400, Nick Bowler wrote:
[...]
> > -		/*
> > -		 * here's the WFI
> > -		 */
> > -		asm(".word	0xe320f003\n"
> > +		asm("wfi\n"
> >  		    :
> >  		    :
> >  		    : "memory", "cc");
> 
> There's a wfi() macro defined in arch/arm/include/asm/system.h that 
> could be used here.

Indeed, thanks for pointing that out.

I'm a little wary, however: the wfi macro does not include the "cc"
clobber that this code has currently, and I don't know what the
implications of removing it are.  There appears to be no current
users of the wfi macro.

Taking a closer look, there appear to be five platforms that have a
hardcoded WFI just like the above (including the "cc" clobber):
exynos4, realview, shmobile, tegra and vexpress.  omap defines its
own do_wfi macro, *without* the "cc" clobber.

Nevertheless, using the macro seems to work just fine, so I can
certainly re-spin the patch with that instead.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
