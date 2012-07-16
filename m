Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab2GPHKb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 03:10:31 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:48908 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330Ab2GPHK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 03:10:28 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19wMnbxttKYtvQHGNeH5UTD
Date: Mon, 16 Jul 2012 00:10:18 -0700
From: Tony Lindgren <tony@atomide.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Olof Johansson <olof@lixom.net>, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] pinctrl: Add one-register-per-pin type device tree
 based pinctrl driver
Message-ID: <20120716071017.GC6522@atomide.com>
References: <20120618055036.GU12766@atomide.com>
 <20120619135600.GX12766@atomide.com>
 <4FE39C86.5070901@wwwdotorg.org>
 <20120622083955.GZ12766@atomide.com>
 <4FE4AC40.8080400@wwwdotorg.org>
 <20120626134319.GA3483@atomide.com>
 <4FE9EBEC.9040208@wwwdotorg.org>
 <20120627102851.GC3483@atomide.com>
 <20120710091131.GQ1122@atomide.com>
 <CACRpkdYUJ3v-DoVbK6Pc6Y833Hn_0KS9PtEpjUCnMr57zfH5Bw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYUJ3v-DoVbK6Pc6Y833Hn_0KS9PtEpjUCnMr57zfH5Bw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Walleij <linus.walleij@linaro.org> [120714 13:21]:
> On Tue, Jul 10, 2012 at 11:11 AM, Tony Lindgren <tony@atomide.com> wrote:
> 
> > OK so no comments for a while. Here's the patch updated to leave out
> > the comments in the binding example.
> 
> I reason like this:
> 
> - My fears is that the code gets hopeless to understand the mux, the
>  only way to understand that aspect of the system will be to read the DTS
>  and have the data sheet ready at hand.

Yes that is a valid concern. Once we have the preprocessing available
for DTS files reading should be easier. Also user space tools can be
developed for showing the package specific data in detailed form.
 
> But:
> 
> - Tony knows what he's doing and what is best for OMAP. And this gets
>  (hopefully) all that OMAP mux code out of arch/arm.

Heh thanks for the positive feedback ;) Yes this should allow us to
drop close to 8k lines of data and code from arch/arm/mach-omap2 
once the conversion is done. I'm planning to drop the unused entries
first to cut down the data quite a bit. And already omap5 and am33xx
are DT only and using pinctrl-single to start with. The remaining
legacy mux code can be dropped once we are done with the DT conversion.

> - Surely it will be better to go through this subsystem if we're refactoring
>   it all again later, and all drivers can be transferred to the abstract
>   pinctrl API which is a big win in itself, bringing coherency to the
>   drivers/* at large.
> 
> So applied it, so it can be evaluated in real operating environments.
> 
> But if I don't see OMAP transferred to use this I'll simply delete it
> again. :-)

OK thanks, for reference some am33xx patches for beagle bone already
got posted using an earlier revision of this binding:

http://www.mail-archive.com/linux-omap@vger.kernel.org/msg71695.html

Regards,

Tony
