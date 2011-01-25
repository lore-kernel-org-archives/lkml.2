Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab1AYRZa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 12:25:30 -0500
Received: from 26.mail-out.ovh.net ([91.121.27.225]:38536 "HELO
	26.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753345Ab1AYRZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 12:25:26 -0500
Date: Tue, 25 Jan 2011 18:23:47 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Julia Lawall <julia@diku.dk>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ryan Mallon <ryan@bluewatersys.com>,
        Vasiliy Kulikov <segooon@gmail.com>, kernel-janitors@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Victor <linux@maxim.org.za>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] arch/arm/mach-at91/clock.c: Add missing IS_ERR test
Message-ID: <20110125172347.GC1441@game.jcrosoft.org>
References: <4D3DDD07.1030809@bluewatersys.com>
 <Pine.LNX.4.64.1101242126570.3167@ask.diku.dk>
 <4D3DE35B.1030102@bluewatersys.com>
 <Pine.LNX.4.64.1101242200500.3167@ask.diku.dk>
 <4D3DE9CD.2040800@bluewatersys.com>
 <Pine.LNX.4.64.1101242231240.3167@ask.diku.dk>
 <4D3DF46A.1030009@bluewatersys.com>
 <20110124232302.GQ24104@n2100.arm.linux.org.uk>
 <20110125014428.GO24284@game.jcrosoft.org>
 <Pine.LNX.4.64.1101250712110.29909@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1101250712110.29909@ask.diku.dk>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 549720630476975104
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07:12 Tue 25 Jan     , Julia Lawall wrote:
> On Tue, 25 Jan 2011, Jean-Christophe PLAGNIOL-VILLARD wrote:
> 
> > On 23:23 Mon 24 Jan     , Russell King - ARM Linux wrote:
> > > On Tue, Jan 25, 2011 at 10:51:38AM +1300, Ryan Mallon wrote:
> > > > You could, but it would not be helpful. Clock associations are used so
> > > > that _different_ devices can have the same function and map to the
> > > > correct clock. This is used when there are multiple instances of a
> > > > single peripheral. For example, the uart clocks work like this:
> > > > 
> > > > 	at91_clock_associate("usart1_clk", &pdev->dev, "usart");
> > > > 
> > > > so then you can do this in a driver:
> > > > 	
> > > > 	uart_clk = clk_get(&pdev->dev, "usart");
> > > > 
> > > > Rather than:
> > > > 
> > > > 	uart_clk = clk_get(NULL, "usart1_clk");
> > > > 
> > > > The former will find the correct uart clock for the device. Because each
> > > > uart is a separate device the correct clock will be selected for each uart.
> > > > 	
> > > > My point was that there should be no overlap between clk->name and
> > > > clk->function otherwise clk_get will not be able to return the correct
> > > > clock.
> > > 
> > > It would be nice if AT91 could switch over to using clkdev at some
> > > point, which greatly helps with associating struct clk's with their
> > > device/function names - and reduces the amount of "different" code.
> > I working on it that's was one of the reason I move clkdev to drivers
> > as AT91 and AVR32 need to switch
> 
> Shall I just leave the patch as is then?
I'll try to send a patch before chinese new year

Best Regards,
J.
