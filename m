Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298Ab1K2MLj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 07:11:39 -0500
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:4987 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753130Ab1K2MLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 07:11:34 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EADDL1E5R8sT5/2dsb2JhbABDqnSBBoFyAQEEAScTHCMQCAMOOBQlAyETiAUCtxkSiwwElFOSEw
Date: Tue, 29 Nov 2011 13:08:07 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Marc Vertes <marc.vertes@sigfox.com>, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org,
        Dimitry Andric <dimitry.andric@tomtom.com>,
        Ben Dooks <ben@simtec.co.uk>
Subject: Re: [PATCH] watchdog: add nowayout helpers to Watchdog Timer
	Driver Kernel API
Message-ID: <20111129120807.GM23376@infomag.iguana.be>
References: <20111129111430.GA17609@infomag.iguana.be> <20111129113124.GE5455@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111129113124.GE5455@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

> > diff --git a/Documentation/watchdog/00-INDEX b/Documentation/watchdog/00-INDEX
> > index fc51128..fc9082a 100644
> > --- a/Documentation/watchdog/00-INDEX
> > +++ b/Documentation/watchdog/00-INDEX
> > @@ -1,5 +1,7 @@
> >  00-INDEX
> >  	- this file.
> > +convert_drivers_to_kernel_api.txt
> > +	- how-to for converting old watchdog drivers to the new kernel API.
> 
> Since the howto needs a NOWAYOUT-update as well, I suggest I'll send a
> patch for that and take care of the missing index-entry there?

Ok.

> > @@ -142,6 +142,14 @@ bit-operations. The status bits that are defined are:
> >  * WDOG_NO_WAY_OUT: this bit stores the nowayout setting for the watchdog.
> >    If this bit is set then the watchdog timer will not be able to stop.
> >  
> > +To set the WDOG_NO_WAY_OUT status bit (before registering your watchdog
> > +timer device) you can either:
> > +* set it statically in your watchdog_device struct with
> > +	.status = WATCHDOG_NOWAYOUT_INIT_STATUS,
> > +  (this will set the value the same as CONFIG_WATCHDOG_NOWAYOUT) or
> > +* use the following helper function:
> > +static inline void watchdog_set_nowayout(struct watchdog_device *wdd, int nowayout)
> > +
> 
> I think one level of indentation would be helpful here so it visually
> belongs to the WDOG_NO_WAY_OUT paragraph?

Will fix that.

> > +/* Use the following function to set the nowayout feature */
> > +static inline void watchdog_set_nowayout(struct watchdog_device *wdd, int nowayout)
> > +{
> > +	if (nowayout)
> > +		set_bit(WDOG_NO_WAY_OUT, &wdd->status);
> > +}
> > +
> 
> Other than that:
> 
> Reviewed-by: Wolfram Sang <w.sang@pengutronix.de>
> 
> So, shall I fix the s3c-driver based on that or will you do?

Will included the fix in the final patch.

Kind regards,
Wim.

