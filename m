Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab1IXGah (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 02:30:37 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:56220 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab1IXGaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 02:30:35 -0400
Date: Sat, 24 Sep 2011 00:30:33 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: "Munegowda, Keshava" <keshava_mgowda@ti.com>
cc: parthab@india.ti.com, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        b-cousson@ti.com, balbi@ti.com, gadiyar@ti.com, sameo@linux.intel.com,
        tony@atomide.com, khilman@ti.com, johnstul@us.ibm.com,
        vishwanath.bs@ti.com
Subject: Re: [PATCH 2/5 v11] arm: omap: usb: ehci and ohci hwmod structures
 for omap3
In-Reply-To: <CAP05o4+Zc2z6sBOX_rQeoDQ9PneypcLRCyBbaaB2m+ZjeXZnaw@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1109240020510.22872@utopia.booyaka.com>
References: <1316691479-1849-1-git-send-email-keshava_mgowda@ti.com> <1316691479-1849-2-git-send-email-keshava_mgowda@ti.com> <1316691479-1849-3-git-send-email-keshava_mgowda@ti.com> <alpine.DEB.2.00.1109221115320.10719@utopia.booyaka.com>
 <CAP05o4+Zc2z6sBOX_rQeoDQ9PneypcLRCyBbaaB2m+ZjeXZnaw@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Sep 2011, Munegowda, Keshava wrote:

> On Thu, Sep 22, 2011 at 11:31 PM, Paul Walmsley <paul@pwsan.com> wrote:
> 
> But the question arises here , why do we need these ehci and ohci as two 
> different hwmods containing only irq and base address? It is required 
> for future - to implement remote wakeup feature for ehci and ohci ports 
> depending on irq-chain handler patches by Tero. Separate hwmods for ehci 
> and ohci are needed to enable prcm chain-handler to uniquely identify 
> the wakeup source as ehci or ohci and call only the corresponding 
> interrupt handler. We will be using omap_hwmod_mux_init for ehci and 
> ohci hwmods to enable I/O wakeup capability for respective IO-pads. 
> Depending on the particular wakeup source(ehci/ohci), the corresponding 
> ehci or ohci irq handler will be called.
> 
> If ehci and ohci are combined with usbhs hwmod as a single hwmod , then 
> for every wakeup (either ehci or ohci port wakeup) only the first 
> interrupt handler will be called (please look at the function 
> omap_hwmod_mux_handle_irq of
> 
> /arch/arm/mach-omap2/mux.c file ; in tero's latest patch:
> http://www.mail-archive.com/linux-omap@vger.kernel.org/msg53139.html)
> , so in this
> case, if ehci interrupt is the first interrupt , then even for ohci wakeup
> , only ehci interrupt will get called; which will break the functionality.

Any reason why this couldn't be handled either by:

1. adding an IRQ number field to struct omap_hwmod_mux_info, and changing
_omap_hwmod_mux_handle_irq() to raise that IRQ number?

or 

2. using shared interrupts?


- Paul
