Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab1LIWlF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 17:41:05 -0500
Received: from the.earth.li ([46.43.34.31]:44727 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079Ab1LIWlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 17:41:01 -0500
X-Greylist: delayed 2483 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Dec 2011 17:41:01 EST
Date: Fri, 9 Dec 2011 14:00:06 -0800
From: Jonathan McDowell <noodles@earth.li>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Cory Maccarrone <darkstar6262@gmail.com>,
        Laurent Gonzalez <palmte.linux@free.fr>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH 2/3] video: omap: convert drivers/video/omap/* to use
 module_platform_driver()
Message-ID: <20111209220006.GG16333@earth.li>
References: <1323395873.3740.4.camel@phoenix>
 <1323395996.3740.6.camel@phoenix>
 <201112090924.29551.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112090924.29551.marek.vasut@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 09, 2011 at 09:24:29AM +0100, Marek Vasut wrote:
> > This patch converts the drivers in drivers/video/omap/* to use the
> > module_platform_driver() macro which makes the code smaller and a bit
> > simpler.
> > 
> > Cc: Jonathan McDowell <noodles@earth.li>
> > Cc: Cory Maccarrone <darkstar6262@gmail.com>
> > Cc: Laurent Gonzalez <palmte.linux@free.fr>
> > Cc: Marek Vasut <marek.vasut@gmail.com>
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> > ---
> >  drivers/video/omap/lcd_ams_delta.c |   13 +------------
> >  drivers/video/omap/lcd_h3.c        |   14 +-------------
> >  drivers/video/omap/lcd_htcherald.c |   14 +-------------
> >  drivers/video/omap/lcd_inn1510.c   |   14 +-------------
> >  drivers/video/omap/lcd_inn1610.c   |   14 +-------------
> >  drivers/video/omap/lcd_osk.c       |   14 +-------------
> >  drivers/video/omap/lcd_palmte.c    |   14 +-------------
> >  drivers/video/omap/lcd_palmtt.c    |   13 +------------
> >  drivers/video/omap/lcd_palmz71.c   |   13 +------------
> >  9 files changed, 9 insertions(+), 114 deletions(-)
> > 
> > diff --git a/drivers/video/omap/lcd_ams_delta.c
> > b/drivers/video/omap/lcd_ams_delta.c index eb50a95..0fdd6f6 100644
> > --- a/drivers/video/omap/lcd_ams_delta.c
> > +++ b/drivers/video/omap/lcd_ams_delta.c
> > @@ -209,15 +209,4 @@ static struct platform_driver ams_delta_panel_driver =
> > { },
> >  };
> > 
> > -static int __init ams_delta_panel_drv_init(void)
> > -{
> > -	return platform_driver_register(&ams_delta_panel_driver);
> > -}
> > -
> > -static void __exit ams_delta_panel_drv_cleanup(void)
> > -{
> > -	platform_driver_unregister(&ams_delta_panel_driver);
> > -}
> > -
> > -module_init(ams_delta_panel_drv_init);
> > -module_exit(ams_delta_panel_drv_cleanup);
> > +module_platform_driver(ams_delta_panel_driver);
> > diff --git a/drivers/video/omap/lcd_h3.c b/drivers/video/omap/lcd_h3.c
> > index baec34e..49bdeca 100644
> > --- a/drivers/video/omap/lcd_h3.c
> > +++ b/drivers/video/omap/lcd_h3.c
> > @@ -124,16 +124,4 @@ static struct platform_driver h3_panel_driver = {
> >  	},
> >  };
> > 
> > -static int __init h3_panel_drv_init(void)
> > -{
> > -	return platform_driver_register(&h3_panel_driver);
> > -}
> > -
> > -static void __exit h3_panel_drv_cleanup(void)
> > -{
> > -	platform_driver_unregister(&h3_panel_driver);
> > -}
> > -
> > -module_init(h3_panel_drv_init);
> > -module_exit(h3_panel_drv_cleanup);
> > -
> > +module_platform_driver(h3_panel_driver);
> > diff --git a/drivers/video/omap/lcd_htcherald.c
> > b/drivers/video/omap/lcd_htcherald.c index b1a022f..20f4778 100644
> > --- a/drivers/video/omap/lcd_htcherald.c
> > +++ b/drivers/video/omap/lcd_htcherald.c
> > @@ -115,16 +115,4 @@ static struct platform_driver htcherald_panel_driver =
> > { },
> >  };
> > 
> > -static int __init htcherald_panel_drv_init(void)
> > -{
> > -	return platform_driver_register(&htcherald_panel_driver);
> > -}
> > -
> > -static void __exit htcherald_panel_drv_cleanup(void)
> > -{
> > -	platform_driver_unregister(&htcherald_panel_driver);
> > -}
> > -
> > -module_init(htcherald_panel_drv_init);
> > -module_exit(htcherald_panel_drv_cleanup);
> > -
> > +module_platform_driver(htcherald_panel_driver);
> > diff --git a/drivers/video/omap/lcd_inn1510.c
> > b/drivers/video/omap/lcd_inn1510.c index d129946..b38b1dd 100644
> > --- a/drivers/video/omap/lcd_inn1510.c
> > +++ b/drivers/video/omap/lcd_inn1510.c
> > @@ -109,16 +109,4 @@ static struct platform_driver
> > innovator1510_panel_driver = { },
> >  };
> > 
> > -static int __init innovator1510_panel_drv_init(void)
> > -{
> > -	return platform_driver_register(&innovator1510_panel_driver);
> > -}
> > -
> > -static void __exit innovator1510_panel_drv_cleanup(void)
> > -{
> > -	platform_driver_unregister(&innovator1510_panel_driver);
> > -}
> > -
> > -module_init(innovator1510_panel_drv_init);
> > -module_exit(innovator1510_panel_drv_cleanup);
> > -
> > +module_platform_driver(innovator1510_panel_driver);
> > diff --git a/drivers/video/omap/lcd_inn1610.c
> > b/drivers/video/omap/lcd_inn1610.c index a95756b..7e8bd8e 100644
> > --- a/drivers/video/omap/lcd_inn1610.c
> > +++ b/drivers/video/omap/lcd_inn1610.c
> > @@ -133,16 +133,4 @@ static struct platform_driver
> > innovator1610_panel_driver = { },
> >  };
> > 
> > -static int __init innovator1610_panel_drv_init(void)
> > -{
> > -	return platform_driver_register(&innovator1610_panel_driver);
> > -}
> > -
> > -static void __exit innovator1610_panel_drv_cleanup(void)
> > -{
> > -	platform_driver_unregister(&innovator1610_panel_driver);
> > -}
> > -
> > -module_init(innovator1610_panel_drv_init);
> > -module_exit(innovator1610_panel_drv_cleanup);
> > -
> > +module_platform_driver(innovator1610_panel_driver);
> > diff --git a/drivers/video/omap/lcd_osk.c b/drivers/video/omap/lcd_osk.c
> > index b985997..5914220 100644
> > --- a/drivers/video/omap/lcd_osk.c
> > +++ b/drivers/video/omap/lcd_osk.c
> > @@ -127,16 +127,4 @@ static struct platform_driver osk_panel_driver = {
> >  	},
> >  };
> > 
> > -static int __init osk_panel_drv_init(void)
> > -{
> > -	return platform_driver_register(&osk_panel_driver);
> > -}
> > -
> > -static void __exit osk_panel_drv_cleanup(void)
> > -{
> > -	platform_driver_unregister(&osk_panel_driver);
> > -}
> > -
> > -module_init(osk_panel_drv_init);
> > -module_exit(osk_panel_drv_cleanup);
> > -
> > +module_platform_driver(osk_panel_driver);
> > diff --git a/drivers/video/omap/lcd_palmte.c
> > b/drivers/video/omap/lcd_palmte.c index d79f436..88c31eb 100644
> > --- a/drivers/video/omap/lcd_palmte.c
> > +++ b/drivers/video/omap/lcd_palmte.c
> > @@ -108,16 +108,4 @@ static struct platform_driver palmte_panel_driver = {
> >  	},
> >  };
> > 
> > -static int __init palmte_panel_drv_init(void)
> > -{
> > -	return platform_driver_register(&palmte_panel_driver);
> > -}
> > -
> > -static void __exit palmte_panel_drv_cleanup(void)
> > -{
> > -	platform_driver_unregister(&palmte_panel_driver);
> > -}
> > -
> > -module_init(palmte_panel_drv_init);
> > -module_exit(palmte_panel_drv_cleanup);
> > -
> > +module_platform_driver(palmte_panel_driver);
> > diff --git a/drivers/video/omap/lcd_palmtt.c
> > b/drivers/video/omap/lcd_palmtt.c index c2e96a7..aaf3c8b 100644
> > --- a/drivers/video/omap/lcd_palmtt.c
> > +++ b/drivers/video/omap/lcd_palmtt.c
> > @@ -113,15 +113,4 @@ static struct platform_driver palmtt_panel_driver = {
> >  	},
> >  };
> > 
> > -static int __init palmtt_panel_drv_init(void)
> > -{
> > -	return platform_driver_register(&palmtt_panel_driver);
> > -}
> > -
> > -static void __exit palmtt_panel_drv_cleanup(void)
> > -{
> > -	platform_driver_unregister(&palmtt_panel_driver);
> > -}
> > -
> > -module_init(palmtt_panel_drv_init);
> > -module_exit(palmtt_panel_drv_cleanup);
> > +module_platform_driver(palmtt_panel_driver);
> > diff --git a/drivers/video/omap/lcd_palmz71.c
> > b/drivers/video/omap/lcd_palmz71.c index 1ab4847..3b7d8aa 100644
> > --- a/drivers/video/omap/lcd_palmz71.c
> > +++ b/drivers/video/omap/lcd_palmz71.c
> > @@ -109,15 +109,4 @@ static struct platform_driver palmz71_panel_driver = {
> >  	},
> >  };
> > 
> > -static int __init palmz71_panel_drv_init(void)
> > -{
> > -	return platform_driver_register(&palmz71_panel_driver);
> > -}
> > -
> > -static void __exit palmz71_panel_drv_cleanup(void)
> > -{
> > -	platform_driver_unregister(&palmz71_panel_driver);
> > -}
> > -
> > -module_init(palmz71_panel_drv_init);
> > -module_exit(palmz71_panel_drv_cleanup);
> > +module_platform_driver(palmz71_panel_driver);
> 
> PalmTT and PalmZ71, please add my
> Acked-by: Marek Vasut <marek.vasut@gmail.com>

For ams-delta,

Acked-By: Jonathan McDowell <noodles@earth.li>

J.

-- 
                                            xmpp:noodles@earth.li
Time is an illusion. Lunchtime doubly so.
