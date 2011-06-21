Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187Ab1FURMD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 13:12:03 -0400
Received: from 27.98.mail-out.ovh.net ([178.33.105.219]:59051 "EHLO
	98.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756666Ab1FURMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 13:12:01 -0400
X-Greylist: delayed 8936 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Jun 2011 13:12:01 EDT
Date: Tue, 21 Jun 2011 16:28:40 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Patrice Vilchez <patrice.vilchez@atmel.com>,
        Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] atmel_serial: keep the platform_device unchanged
Message-ID: <20110621142840.GW7881@game.jcrosoft.org>
References: <1302724038-26236-1-git-send-email-plagnioj@jcrosoft.com>
 <1307522703.10626.9.camel@hcegtvedt.norway.atmel.com>
 <20110608134730.GA17584@game.jcrosoft.org>
 <1307541740.10626.15.camel@hcegtvedt.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307541740.10626.15.camel@hcegtvedt.norway.atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 12534362188607695870
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -330
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16:02 Wed 08 Jun     , Hans-Christian Egtvedt wrote:
> On Wed, 2011-06-08 at 15:47 +0200, Jean-Christophe PLAGNIOL-VILLARD
> wrote:
> > On 10:45 Wed 08 Jun     , Hans-Christian Egtvedt wrote:
> > > On Wed, 2011-04-13 at 21:47 +0200, Jean-Christophe PLAGNIOL-VILLARD
> > > wrote:
> 
> <snipp>
> 
> > > > diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
> > > > index bfc9d07..aa677e2 100644
> > > > --- a/arch/avr32/mach-at32ap/at32ap700x.c
> > > > +++ b/arch/avr32/mach-at32ap/at32ap700x.c
> > > > @@ -1014,6 +1014,7 @@ static struct platform_device *__initdata at32_usarts[4];
> > > >  void __init at32_map_usart(unsigned int hw_id, unsigned int line, int flags)
> > > >  {
> > > >  	struct platform_device *pdev;
> > > > +	struct atmel_uart_data *pdata;
> > > >  
> > > >  	switch (hw_id) {
> > > >  	case 0:
> > > > @@ -1042,7 +1043,8 @@ void __init at32_map_usart(unsigned int hw_id, unsigned int line, int flags)
> > > >  		data->regs = (void __iomem *)pdev->resource[0].start;
> > > >  	}
> > > >  
> > > > -	pdev->id = line;
> > > 
> > > AVR32 needs this to be present to work independent of which USART
> > > peripheral the user chooses to use for console.
> > > 
> > > > +	pdata = pdev->dev.platform_data;
> > > > +	pdata->num = portnr;
> > here supposed to be
> > 	pdata->num = line;
> 
> I know, but that doesn't fix the problem about not able to find a
> console, the platform data id must also be 0 (if console is on ttyS0)
> AFAICT.
I found the issue
on at91 we always use the dbgu as console so I did not see it

please try to repling patch

Best Regards,
J.
