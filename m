Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab1FHOkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 10:40:40 -0400
Received: from 97.mail-out.ovh.net ([91.121.185.90]:46543 "EHLO
	97.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628Ab1FHOkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 10:40:39 -0400
Date: Wed, 8 Jun 2011 15:47:30 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Patrice Vilchez <patrice.vilchez@atmel.com>,
        Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] atmel_serial: keep the platform_device unchanged
Message-ID: <20110608134730.GA17584@game.jcrosoft.org>
References: <1302724038-26236-1-git-send-email-plagnioj@jcrosoft.com>
 <1307522703.10626.9.camel@hcegtvedt.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307522703.10626.9.camel@hcegtvedt.norway.atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 9262215584928082942
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -300
X-VR-SPAMCAUSE: Vade Retro 01.320.21 AV+AS Profile: OVH; Bailout: 300; @!Recipients (-100); (-100);void,int (-100)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10:45 Wed 08 Jun     , Hans-Christian Egtvedt wrote:
> On Wed, 2011-04-13 at 21:47 +0200, Jean-Christophe PLAGNIOL-VILLARD
> wrote:
> > specify the port num via platform_data this will allow to match the clock
> > with the plaform_dev staticly
> 
> Sure this works as intended, now the platform device id is off, and at
> least for my 3.0 testing it is no longer able to open the console,
> unless I explicit set the id field again.
> 
> Example on NGW100 mkII I use USART instance 1 as serial console, if not
> setting the platform device id to 0 (re-mapping), then I get a warning
> about unable to open console.
> 
> Is you clock optimization an additional patch?
no but we can also switch the avr32 to clkdev
> 
> <snipp AT91 changes)
> 
> > diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
> > index bfc9d07..aa677e2 100644
> > --- a/arch/avr32/mach-at32ap/at32ap700x.c
> > +++ b/arch/avr32/mach-at32ap/at32ap700x.c
> > @@ -1014,6 +1014,7 @@ static struct platform_device *__initdata at32_usarts[4];
> >  void __init at32_map_usart(unsigned int hw_id, unsigned int line, int flags)
> >  {
> >  	struct platform_device *pdev;
> > +	struct atmel_uart_data *pdata;
> >  
> >  	switch (hw_id) {
> >  	case 0:
> > @@ -1042,7 +1043,8 @@ void __init at32_map_usart(unsigned int hw_id, unsigned int line, int flags)
> >  		data->regs = (void __iomem *)pdev->resource[0].start;
> >  	}
> >  
> > -	pdev->id = line;
> 
> AVR32 needs this to be present to work independent of which USART
> peripheral the user chooses to use for console.
> 
> > +	pdata = pdev->dev.platform_data;
> > +	pdata->num = portnr;
here supposed to be
	pdata->num = line;

Best Regards,
J.
