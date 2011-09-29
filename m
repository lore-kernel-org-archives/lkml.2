Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161Ab1I2IIK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 04:08:10 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38685 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727Ab1I2IIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 04:08:06 -0400
Date: Thu, 29 Sep 2011 09:07:53 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Richard Purdie <richard.purdie@linuxfoundation.org>
Cc: Bryan Wu <bryan.wu@canonical.com>, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] leds-class: change back LEDS_CLASS to tristate
	instead of bool
Message-ID: <20110929080753.GC23944@n2100.arm.linux.org.uk>
References: <1315249786-15387-1-git-send-email-bryan.wu@canonical.com> <1315252298.1243.21.camel@ted>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315252298.1243.21.camel@ted>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 05, 2011 at 08:51:38PM +0100, Richard Purdie wrote:
> On Tue, 2011-09-06 at 03:09 +0800, Bryan Wu wrote:
> > LEDS_CLASS is required by leds and trigger drivers, but we can build it
> > as module. So change this option back as tristate and treak the help
> > message as well.
> > 
> > Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
> 
> Acked-by: Richard Purdie <rchard.purdie@linuxfoundation.org>
> 
> > ---
> >  drivers/leds/Kconfig |    7 +++++--
> >  1 files changed, 5 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
> > index b591e72..1c35927 100644
> > --- a/drivers/leds/Kconfig
> > +++ b/drivers/leds/Kconfig
> > @@ -17,10 +17,13 @@ menuconfig NEW_LEDS
> >  if NEW_LEDS
> >  
> >  config LEDS_CLASS
> > -	bool "LED Class Support"
> > +	tristate "LED Class Support"
> >  	help
> >  	  This option enables the led sysfs class in /sys/class/leds.  You'll
> > -	  need this to do anything useful with LEDs.  If unsure, say N.
> > +	  need this to do anything useful with LEDs.  If unsure, say M.
> > +
> > +	  Note: don't disable it as N, because plenty of led and trigger drivers
> > +	  are using this option.

This is crap - putting a dependency in the help for an option is
unacceptable when we have things like randconfig etc which are
expected to work.

If this must be 'm' or 'y', then make it depend on m to force the
minimum setting.
