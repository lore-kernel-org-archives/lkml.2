Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab1IEO1f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 10:27:35 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:21425 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942Ab1IEO1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 10:27:33 -0400
Date: Mon, 5 Sep 2011 16:27:10 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Luciano Coelho <coelho@ti.com>, Randy Dunlap <rdunlap@xenotime.net>,
        matti.j.aaltonen@nokia.com, johannes@sipsolutions.net,
        linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/2] misc: remove CONFIG_MISC_DEVICES
Message-ID: <20110905162710.348c380f@endymion.delvare>
In-Reply-To: <201109051619.35553.arnd@arndb.de>
References: <20110829102732.03f0f05d.rdunlap@xenotime.net>
	<201109021643.14275.arnd@arndb.de>
	<20110905144134.2c80c4b9@endymion.delvare>
	<201109051619.35553.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Sep 2011 16:19:35 +0200, Arnd Bergmann wrote:
> On Monday 05 September 2011, Jean Delvare wrote:
> > As said before, I'm not sure. Yes, it makes it easier to select misc
> > device drivers from Kconfig files. But it also makes it impossible to
> > deselect all misc device drivers at once.
> > 
> > I think that what we really need is the implementation in the Kconfig
> > system of smart selects, i.e. whenever an entry is selected, everything
> > it depends on gets selected as well. I don't know how feasible this is,
> > but if it can be done then I'd prefer this to your proposal.
> > 
> > Meanwhile, I am not in favor of applying your patch. The benefit is
> > relatively small IMHO (misc device drivers are rarely selected) and
> > there is one significant drawback.
> 
> Before I made this patch, I started a different one that added about
> a dozen 'select MISC_DEVICES' statements sprinkled all over the kernel
> in order to silence the Kconfig warnings.

Ah, OK. This certainly shifts the scales towards your side.

> The problem is that whenever you select that option, the misc directory
> suddenly becomes visible when it was disabled before, and things like
> 'oldconfig' will start asking about all other misc drivers as well.

Another good point. Maybe I'm convinced now.

> I think it would simply be more consistent to have it enabled all
> the time. Well, even better would be to move the bulk of the misc
> drivers to a proper location sorted by their subsystems. A lot of them
> should never have been merged in their current state IMHO.

As one of the offenders, I won't dare to comment on this ;)

> > That being said, I'm not the one to decide, so if you can convince
> > someone with more power (aka Andrew Morton)...
> 
> I think I should finally do what has been  talked about a few times and
> formally become the maintainer of drivers/char and drivers/misc ;-)
> 
> The problem is that I'm not actually a good maintainer, but maybe it's
> better to just have someone instead of falling back to Andrew or
> some random subsystem maintainer to send any patches for drivers/misc.

Certainly. And having a maintainer for these (non-)subsystems would
certainly help keep their size low, while the current trend is in the
other direction.

-- 
Jean Delvare
