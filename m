Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038Ab1AYGMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 01:12:41 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:39934 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752731Ab1AYGMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 01:12:40 -0500
Date: Tue, 25 Jan 2011 07:12:34 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ryan Mallon <ryan@bluewatersys.com>,
        Vasiliy Kulikov <segooon@gmail.com>, kernel-janitors@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Victor <linux@maxim.org.za>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] arch/arm/mach-at91/clock.c: Add missing IS_ERR test
In-Reply-To: <20110125014428.GO24284@game.jcrosoft.org>
Message-ID: <Pine.LNX.4.64.1101250712110.29909@ask.diku.dk>
References: <Pine.LNX.4.64.1101242058430.3167@ask.diku.dk>
 <20110124200515.GA30963@albatros> <4D3DDD07.1030809@bluewatersys.com>
 <Pine.LNX.4.64.1101242126570.3167@ask.diku.dk> <4D3DE35B.1030102@bluewatersys.com>
 <Pine.LNX.4.64.1101242200500.3167@ask.diku.dk> <4D3DE9CD.2040800@bluewatersys.com>
 <Pine.LNX.4.64.1101242231240.3167@ask.diku.dk> <4D3DF46A.1030009@bluewatersys.com>
 <20110124232302.GQ24104@n2100.arm.linux.org.uk> <20110125014428.GO24284@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jan 2011, Jean-Christophe PLAGNIOL-VILLARD wrote:

> On 23:23 Mon 24 Jan     , Russell King - ARM Linux wrote:
> > On Tue, Jan 25, 2011 at 10:51:38AM +1300, Ryan Mallon wrote:
> > > You could, but it would not be helpful. Clock associations are used so
> > > that _different_ devices can have the same function and map to the
> > > correct clock. This is used when there are multiple instances of a
> > > single peripheral. For example, the uart clocks work like this:
> > > 
> > > 	at91_clock_associate("usart1_clk", &pdev->dev, "usart");
> > > 
> > > so then you can do this in a driver:
> > > 	
> > > 	uart_clk = clk_get(&pdev->dev, "usart");
> > > 
> > > Rather than:
> > > 
> > > 	uart_clk = clk_get(NULL, "usart1_clk");
> > > 
> > > The former will find the correct uart clock for the device. Because each
> > > uart is a separate device the correct clock will be selected for each uart.
> > > 	
> > > My point was that there should be no overlap between clk->name and
> > > clk->function otherwise clk_get will not be able to return the correct
> > > clock.
> > 
> > It would be nice if AT91 could switch over to using clkdev at some
> > point, which greatly helps with associating struct clk's with their
> > device/function names - and reduces the amount of "different" code.
> I working on it that's was one of the reason I move clkdev to drivers
> as AT91 and AVR32 need to switch

Shall I just leave the patch as is then?

julia
