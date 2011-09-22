Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab1IVSOz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 14:14:55 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:38345 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab1IVSOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 14:14:54 -0400
Date: Thu, 22 Sep 2011 12:14:53 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: Keshava Munegowda <keshava_mgowda@ti.com>, parthab@india.ti.com
cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, b-cousson@ti.com, balbi@ti.com,
        gadiyar@ti.com, sameo@linux.intel.com, tony@atomide.com,
        khilman@ti.com, johnstul@us.ibm.com, vishwanath.bs@ti.com
Subject: Re: [PATCH 1/5 v11] arm: omap: usb: ehci and ohci hwmod structures
 for omap4
In-Reply-To: <1316691479-1849-2-git-send-email-keshava_mgowda@ti.com>
Message-ID: <alpine.DEB.2.00.1109221213500.10719@utopia.booyaka.com>
References: <1316691479-1849-1-git-send-email-keshava_mgowda@ti.com> <1316691479-1849-2-git-send-email-keshava_mgowda@ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thu, 22 Sep 2011, Keshava Munegowda wrote:

> Following 4 hwmod structures are added
> 1. usb_host_hs hwmod of usbhs with uhh base address and functional clock,
> 2. usb_ehci_hs hwmod with irq and base address,
> 3. usb_ohci_hs hwmod with irq and base address,
>    - The ehci and ohci hwmods does not require functional clock
>      because usb_host_hs has functional clock which is sufficient
>      to access ehci and ohci address space.
>    - The usb_ehci_hs and usb_ohci_hs should be two separate hwmods
>      which should not be combined. This is needed because ehci and
>      ohci will have separate dedicated ports & in omap4 there is a
>      clock per port.We should be able to configure the IO-Wakeup
>      capability of pins specific to EHCI & OHCI separately and depending
>      on the I/O wakeup event  the  only port clocks corresponding
>      to the wakeup source will be enabled internally by the usb host driver.
> 
> 4. usb_tll_hs hwmod of usbhs with the TLL base address and irq.

Many of the same issues with the OMAP3 data (missing main_clks, missing 
ADDR_TYPE_RT, etc.) exist with this patch also.


- Paul
