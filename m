Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab1FHOCz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 10:02:55 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:53993 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755208Ab1FHOCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 10:02:53 -0400
Subject: Re: [PATCH] atmel_serial: keep the platform_device unchanged
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Patrice Vilchez <patrice.vilchez@atmel.com>,
        Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <20110608134730.GA17584@game.jcrosoft.org>
References: <1302724038-26236-1-git-send-email-plagnioj@jcrosoft.com>
	 <1307522703.10626.9.camel@hcegtvedt.norway.atmel.com>
	 <20110608134730.GA17584@game.jcrosoft.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Atmel Corporation
Date: Wed, 08 Jun 2011 16:02:20 +0200
Message-ID: <1307541740.10626.15.camel@hcegtvedt.norway.atmel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Jun 2011 14:02:23.0730 (UTC) FILETIME=[B0E26520:01CC25E4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-08 at 15:47 +0200, Jean-Christophe PLAGNIOL-VILLARD
wrote:
> On 10:45 Wed 08 Jun     , Hans-Christian Egtvedt wrote:
> > On Wed, 2011-04-13 at 21:47 +0200, Jean-Christophe PLAGNIOL-VILLARD
> > wrote:

<snipp>

> > > diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
> > > index bfc9d07..aa677e2 100644
> > > --- a/arch/avr32/mach-at32ap/at32ap700x.c
> > > +++ b/arch/avr32/mach-at32ap/at32ap700x.c
> > > @@ -1014,6 +1014,7 @@ static struct platform_device *__initdata at32_usarts[4];
> > >  void __init at32_map_usart(unsigned int hw_id, unsigned int line, int flags)
> > >  {
> > >  	struct platform_device *pdev;
> > > +	struct atmel_uart_data *pdata;
> > >  
> > >  	switch (hw_id) {
> > >  	case 0:
> > > @@ -1042,7 +1043,8 @@ void __init at32_map_usart(unsigned int hw_id, unsigned int line, int flags)
> > >  		data->regs = (void __iomem *)pdev->resource[0].start;
> > >  	}
> > >  
> > > -	pdev->id = line;
> > 
> > AVR32 needs this to be present to work independent of which USART
> > peripheral the user chooses to use for console.
> > 
> > > +	pdata = pdev->dev.platform_data;
> > > +	pdata->num = portnr;
> here supposed to be
> 	pdata->num = line;

I know, but that doesn't fix the problem about not able to find a
console, the platform data id must also be 0 (if console is on ttyS0)
AFAICT.

-- 
Hans-Christian Egtvedt

