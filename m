Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab1C1OUh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 10:20:37 -0400
Received: from cantor.suse.de ([195.135.220.2]:34995 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754433Ab1C1OUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 10:20:35 -0400
Date: Mon, 28 Mar 2011 07:12:37 -0700
From: Greg KH <gregkh@suse.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>,
        devel@driverdev.osuosl.org, Linus Walleij <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Pavan Savoy <pavan_savoy@sify.com>, Vitaly Wool <vitalywool@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Marcel Holtmann <marcel@holtmann.org>,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Par-Gunnar Hjalmdahl <pghatwork@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH v2 2/2] mach-ux500: Add CG2900 devices
Message-ID: <20110328141237.GB19350@suse.de>
References: <1301302992-10671-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
 <201103281500.38954.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103281500.38954.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 03:00:38PM +0200, Arnd Bergmann wrote:
> On Monday 28 March 2011, Par-Gunnar Hjalmdahl wrote:
> > diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
> > index d8e5a52..16b7343 100644
> > --- a/arch/arm/mach-ux500/board-mop500.c
> > +++ b/arch/arm/mach-ux500/board-mop500.c
> > @@ -417,6 +417,8 @@ static void __init mop500_init_machine(void)
> >  
> >         platform_device_register(&ab8500_device);
> >  
> > +       cg2900_init_board();
> > +
> >         i2c_register_board_info(0, mop500_i2c0_devices,
> >                                 ARRAY_SIZE(mop500_i2c0_devices));
> >         i2c_register_board_info(2, mop500_i2c2_devices,
> 
> Not exactly what I had in mind, but probably good enough for a start.
> This adds a dependency from core code to the staging driver now,
> which shouldn't be there. I suppose we can add
> 
> "Clean up device registration path to register the main device from board code"
>  
> to the TODO file.

No, please do not make any core code dependant on a staging driver, this
isn't ok, it needs to be stand-alone, or at the least, the rest of the
kernel needs to be able to be built with no staging drivers enabled.

thanks,

greg k-h
