Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576Ab1IBMAt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 08:00:49 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:57185 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751083Ab1IBMAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 08:00:45 -0400
Subject: Re: [PATCH] mfd: Combine MFD_SUPPORT and MFD_CORE
From: Luciano Coelho <coelho@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Randy Dunlap <rdunlap@xenotime.net>, matti.j.aaltonen@nokia.com,
        johannes@sipsolutions.net, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, mchehab@infradead.org,
        linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>
In-Reply-To: <201108311849.37273.arnd@arndb.de>
References: <20110829102732.03f0f05d.rdunlap@xenotime.net>
	 <1314643307-17780-1-git-send-email-coelho@ti.com>
	 <201108311849.37273.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Sep 2011 14:54:55 +0300
Message-ID: <1314964495.2296.632.camel@cumari>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-31 at 18:49 +0200, Arnd Bergmann wrote: 
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
> enable any of the specific drivers. MFD_SUPPORT was added as a 'menuconfig'
> before we had Kconfig warn about broken dependencies, so everything was
> fine. Since Kconfig now issues the warnings, I think it would be better
> to just turn the MFD menu into a plain 'menu' and remove all the
> 'depends on MFD_SUPPORT' and 'select MFD_SUPPORT' lines from the other
> Kconfig files.

Yes, this makes sense.  I think your solution is indeed cleaner.  If you
want to send it it's fine with me.  I don't really have any preference,
I just wanted to clean a problem that was reported to me. ;)

If you send your changes, my patch can be ignored, otherwise, I can send
a v2 with the changes Jean proposed.


-- 
Cheers,
Luca.

