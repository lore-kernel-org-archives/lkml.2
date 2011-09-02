Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930Ab1IBMhj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 08:37:39 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:13929 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab1IBMhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 08:37:37 -0400
Date: Fri, 2 Sep 2011 14:37:13 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Luciano Coelho <coelho@ti.com>, Randy Dunlap <rdunlap@xenotime.net>,
        matti.j.aaltonen@nokia.com, johannes@sipsolutions.net,
        linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] mfd: Combine MFD_SUPPORT and MFD_CORE
Message-ID: <20110902143713.307bbebe@endymion.delvare>
In-Reply-To: <201108311849.37273.arnd@arndb.de>
References: <20110829102732.03f0f05d.rdunlap@xenotime.net>
	<1314643307-17780-1-git-send-email-coelho@ti.com>
	<201108311849.37273.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Wed, 31 Aug 2011 18:49:37 +0200, Arnd Bergmann wrote:
> On Monday 29 August 2011, Luciano Coelho wrote:
> > From: Randy Dunlap <rdunlap@xenotime.net>
> > 
> > Combine MFD_SUPPORT (which only enabled the remainder of the MFD
> > menu) and MFD_CORE.  This allows other drivers to select MFD_CORE
> > without needing to also select MFD_SUPPORT, which fixes some
> > kconfig unmet dependency warnings.  Modeled after I2C kconfig.
> > 
> > [Forward-ported to 3.1-rc4.  This fixes a warning when some drivers,
> > such as RADIO_WL1273, are selected, but MFD_SUPPORT is not. -- Luca]
> > 
> > Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> > Reported-by: Johannes Berg <johannes@sipsolutions.net>
> > Cc: Jean Delvare <khali@linux-fr.org>
> > Cc: Tony Lindgren <tony@atomide.com>
> > Cc: Grant Likely <grant.likely@secretlab.ca>
> > Signed-off-by: Luciano Coelho <coelho@ti.com>
> > ---
> > 
> > I guess this should fix the problem.  I've simple forward-ported
> > Randy's patch to the latest mainline kernel.  I don't know via which
> > tree this should go in, though.
> > 
> > NOTE: I have not tested this very thoroughly.  But at least
> > omap2plus stuff seems to work okay with this change.  MFD_SUPPORT is
> > also selected by a couple of "tile" platforms defconfigs, but I guess
> > the Kconfig system should take care of it.
> 
> Doing this is a good idea, but incidentally I have just spent some time
> with the same problem and ended up with a solution that I like better,
> which is removing CONFIG_MFD_SUPPORT altogether.
> 
> The point is that there is no use enabling MFD_CORE if you don't also
> enable any of the specific drivers.

Same holds for pretty much every subsystem, right?

> MFD_SUPPORT was added as a 'menuconfig'
> before we had Kconfig warn about broken dependencies, so everything was
> fine. Since Kconfig now issues the warnings, I think it would be better
> to just turn the MFD menu into a plain 'menu' and remove all the
> 'depends on MFD_SUPPORT' and 'select MFD_SUPPORT' lines from the other
> Kconfig files.

This would make it impossible to turn off all MFD drivers at once. I
think this is considered a feature, at least I find it very convenient
to be able to "kill" a subsystem completely. And in the past few years
many subsystems were turned from menu to menuconfig for this reason.
But maybe MFD is a special case here.

Anyway, if you want your patch to be applied, you'll have to send it
for review first, as at this point all we have is Luciano's proposal.

-- 
Jean Delvare
