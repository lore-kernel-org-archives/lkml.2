Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab2JEV1y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 17:27:54 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:56911 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab2JEV1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 17:27:52 -0400
Date: Fri, 5 Oct 2012 17:28:26 -0400
From: Matt Porter <mporter@ti.com>
To: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
Cc: Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Russell King <linux@arm.linux.org.uk>,
        "Cousson, Benoit" <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Paul Walmsley <paul@pwsan.com>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 0/7] uio_pruss cleanup and platform support
Message-ID: <20121005212826.GN11149@beef>
References: <1348861072-14507-1-git-send-email-mporter@ti.com>
 <20121003150058.GB11180@beef>
 <1BAFE6F6C881BF42822005164F1491C33EA9C6B7@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1BAFE6F6C881BF42822005164F1491C33EA9C6B7@DBDE01.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2012 at 04:43:56AM +0000, Hebbar, Gururaja wrote:
> Matt,
> 
> On Wed, Oct 03, 2012 at 20:30:58, Porter, Matt wrote:
> > On Fri, Sep 28, 2012 at 03:37:45PM -0400, Matt Porter wrote:
> > > Changes since v1:
> > > 	- Replaced uio_pruss private SRAM API use with genalloc
> > > 	- Added DA850 platform device and clock support
> > > 	- Added DA850 L3 RAM gen_pool support
> > > 	- Split out DT binding
> > > 
> > > This series enables uio_pruss on both DA850 and AM33xx. The driver
> > > previously was not enabled by any platform and the private SRAM API
> > > was accessing an invalid SRAM bank for use on DA850. For AM33xx,
> > > DT, pinctrl, and runtime PM support are added since AM33xx only
> > > boots via DT.
> > 
> > I'm dropping AM33xx/OMAP support from v3 for this series 
> 
> Just for my clarification, I believe you will be taking up AM33xx/OMAP 
> SRAM support later once you have completed supporting DaVinci. Right?

There's no SRAM support for uio_pruss to be handled for AM33xx, but I
will be posting a separate series with the DT portion and some alternate
hard reset handling implementation. I find the private OMAP reset api to
be very ugly but we might have to go with that for now. I didn't want
the OMAP hard reset portion to hold up the more important part of this
cleanup.

-Matt

> > since the
> > focus has turned to fixing Davinci SRAM to provide genalloc support
> > and the associated use of that in the driver.
> > 
> > I'll have a separate series with AM33xx support since dealing cleanly
> > with external resets on OMAP is a bigger issue.
> > 
> > -Matt
> > _______________________________________________
> > Davinci-linux-open-source mailing list
> > Davinci-linux-open-source@linux.davincidsp.com
> > http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
> > 
> 
> 
> Regards, 
> Gururaja
> _______________________________________________
> Davinci-linux-open-source mailing list
> Davinci-linux-open-source@linux.davincidsp.com
> http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
