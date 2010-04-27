Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890Ab0D0U5Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 16:57:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38911 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754885Ab0D0U5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 16:57:14 -0400
Date: Tue, 27 Apr 2010 22:57:11 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Oliver Neukum <oliver@neukum.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, Nicu Pavel <npavel@ituner.com>,
       Jaya Kumar <jayakumar.lkml@gmail.com>,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>
Subject: Re: [PATCH 2/2] hid: add PM support to PicoLCD device
In-Reply-To: <20100427221648.39735c41@neptune.home>
Message-ID: <alpine.LNX.2.00.1004272256160.9849@pobox.suse.cz>
References: <20100425214003.7e87c6a3@neptune.home> <20100425214306.5d7be049@neptune.home> <alpine.LNX.2.00.1004271525330.9849@pobox.suse.cz> <20100427221648.39735c41@neptune.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Apr 2010, Bruno Prémont wrote:

> > > +#ifdef CONFIG_PM
> > > +static void picolcd_suspend_backlight(struct picolcd_data *data)
> > > +{
> > > +	int bl_power = data->lcd_power;
> > > +	if (!data->backlight)
> > > +		return;
> > > +
> > > +	data->backlight->props.power = FB_BLANK_POWERDOWN;
> > > +	picolcd_set_brightness(data->backlight);
> > > +	data->lcd_power = data->backlight->props.power = bl_power;
> > > +}
> > > +#else
> > > +#define picolcd_suspend_backlight(a)
> > > +#endif /* CONFIG_PM */
> > 
> > Stylistic thing -- it would be nice if this was actually 
> > 
> > static inline void picolcd_suspend_backlight(struct picolcd_data *data)
> > {
> > 	return 0;
> > }
> > 
> > But why do you need to have it defined in !CONFIG_PM situation anyway? 
> > It's not used otherwise at all.
> 
> Yeah, I could drop the #else branch (of #ifconfig CONFIG_PM).

Yup, please do so.

> Is gcc quiet about defined but unused static inline functions?

Yup, -Wunused-function doesn't warn about unused static inline function.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
