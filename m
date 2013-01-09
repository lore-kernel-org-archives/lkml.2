Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349Ab3AIRwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 12:52:24 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:43430 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758023Ab3AIRwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 12:52:22 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18XTDYNqVgRB563V0fwv7AE
Date: Wed, 9 Jan 2013 09:52:15 -0800
From: Tony Lindgren <tony@atomide.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, linux-arch@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Alexandre Courbot <acourbot@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] Proposed removal of IS_ERR_OR_NULL() (was: Re: [PATCH
 1/4] gpiolib: introduce descriptor-based GPIO interface)
Message-ID: <20130109175215.GU14149@atomide.com>
References: <201301091035.23206.arnd@arndb.de>
 <20130109104414.GF3931@n2100.arm.linux.org.uk>
 <20130109111055.GG3931@n2100.arm.linux.org.uk>
 <alpine.LFD.2.02.1301090932400.6300@xanadu.home>
 <20130109150427.GL3931@n2100.arm.linux.org.uk>
 <alpine.LFD.2.02.1301091020580.6300@xanadu.home>
 <20130109155154.GN3931@n2100.arm.linux.org.uk>
 <alpine.LFD.2.02.1301091058070.6300@xanadu.home>
 <20130109162145.GO3931@n2100.arm.linux.org.uk>
 <20130109171206.GQ3931@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130109171206.GQ3931@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Russell King - ARM Linux <linux@arm.linux.org.uk> [130109 09:15]:
> On Wed, Jan 09, 2013 at 04:21:45PM +0000, Russell King - ARM Linux wrote:
> > On Wed, Jan 09, 2013 at 11:09:23AM -0500, Nicolas Pitre wrote:
> > > On Wed, 9 Jan 2013, Russell King - ARM Linux wrote:
> > > 
> > > > On Wed, Jan 09, 2013 at 10:27:53AM -0500, Nicolas Pitre wrote:
> > > > > Anyone with good coccinelle skills around to deal with the users?
> > > > 
> > > > I'm not sure that's a solution.
> > > 
> > > Well, I was thinking that coccinelle could handle the majority of the 
> > > 354 users when the "fix" is obvious enough to be automated.
> > > 
> > > That said, if we want people to fix their code, it is probably necessary 
> > > to merge your patch right away so the warnings are actually being seen, 
> > > and revert it right before the final v3.8 release if the remaining 
> > > warnings are still too numerous.  Repeat with next cycle.
> > 
> > Well, this is what I currently have for arch/arm thus far, and ooh look,
> > we save some lines of code too.
> 
> Actually, the OMAP dmtimer.c code needs a few more fixes while we're
> reviewing this stuff...  This latest patch leaves three files in
> arch/arm still using IS_ERR_OR_NULL() as they do seem to want to
> legitimately check for error pointers _and_ NULL.
> 
> I'm restricting the patch below to just those cases where it's wrong
> in arch/arm.
> 
> The omap_device.c changes probably also deserve some explanation.  As
> far as I can see, if we have an 'od' then 'od->pdev' _must_ already
> be valid (pdev is passed into omap_device_alloc() which creates the
> 'od' - and the passed pdev better be checked _before_ it's passed in.)
> It also appears that oh->od will _never_ be an error pointer value -
> apart from tracing the paths creating that, there is some evidence for
> this with tests elsewhere just for NULL here.  And lastly
> omap_hwmod_lookup() is documented to _only_ return NULL on error, and
> review of it confirms that.

Looks correct to me.

Regards,

Tony
