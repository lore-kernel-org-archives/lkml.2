Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab1AYBqF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 20:46:05 -0500
Received: from 26.mail-out.ovh.net ([91.121.27.225]:44169 "HELO
	26.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751746Ab1AYBqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 20:46:04 -0500
Date: Tue, 25 Jan 2011 02:44:28 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Ryan Mallon <ryan@bluewatersys.com>, Julia Lawall <julia@diku.dk>,
        Vasiliy Kulikov <segooon@gmail.com>, kernel-janitors@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Victor <linux@maxim.org.za>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] arch/arm/mach-at91/clock.c: Add missing IS_ERR test
Message-ID: <20110125014428.GO24284@game.jcrosoft.org>
References: <Pine.LNX.4.64.1101242058430.3167@ask.diku.dk>
 <20110124200515.GA30963@albatros>
 <4D3DDD07.1030809@bluewatersys.com>
 <Pine.LNX.4.64.1101242126570.3167@ask.diku.dk>
 <4D3DE35B.1030102@bluewatersys.com>
 <Pine.LNX.4.64.1101242200500.3167@ask.diku.dk>
 <4D3DE9CD.2040800@bluewatersys.com>
 <Pine.LNX.4.64.1101242231240.3167@ask.diku.dk>
 <4D3DF46A.1030009@bluewatersys.com>
 <20110124232302.GQ24104@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110124232302.GQ24104@n2100.arm.linux.org.uk>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 3131690592184675251
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23:23 Mon 24 Jan     , Russell King - ARM Linux wrote:
> On Tue, Jan 25, 2011 at 10:51:38AM +1300, Ryan Mallon wrote:
> > You could, but it would not be helpful. Clock associations are used so
> > that _different_ devices can have the same function and map to the
> > correct clock. This is used when there are multiple instances of a
> > single peripheral. For example, the uart clocks work like this:
> > 
> > 	at91_clock_associate("usart1_clk", &pdev->dev, "usart");
> > 
> > so then you can do this in a driver:
> > 	
> > 	uart_clk = clk_get(&pdev->dev, "usart");
> > 
> > Rather than:
> > 
> > 	uart_clk = clk_get(NULL, "usart1_clk");
> > 
> > The former will find the correct uart clock for the device. Because each
> > uart is a separate device the correct clock will be selected for each uart.
> > 	
> > My point was that there should be no overlap between clk->name and
> > clk->function otherwise clk_get will not be able to return the correct
> > clock.
> 
> It would be nice if AT91 could switch over to using clkdev at some
> point, which greatly helps with associating struct clk's with their
> device/function names - and reduces the amount of "different" code.
I working on it that's was one of the reason I move clkdev to drivers
as AT91 and AVR32 need to switch

Best Regards,
J.
