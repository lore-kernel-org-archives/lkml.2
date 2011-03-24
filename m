Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265Ab1CXVlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 17:41:18 -0400
Received: from mail.bluewatersys.com ([202.124.120.130]:57538 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756735Ab1CXVlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 17:41:16 -0400
Message-ID: <4D8BBA8A.3080408@bluewatersys.com>
Date: Fri, 25 Mar 2011 10:41:30 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [patch 1/3] arm/gpio: Remove three copies of broken and racy
 debug	code
References: <20110324212330.292903803@linutronix.de> <20110324212508.931638262@linutronix.de>
In-Reply-To: <20110324212508.931638262@linutronix.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2011 10:27 AM, Thomas Gleixner wrote:
> gpiolib plus two gpio implementations in arm fiddle in the guts of
> irq_desc in a racy and buggy way. Remove the stuff. I already told the
> gpio folks that we can provide that information in a proper way if
> necessary.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  arch/arm/mach-ep93xx/gpio.c  |   39 -------------------------------------
>  arch/arm/plat-nomadik/gpio.c |   45 -------------------------------------------
>  drivers/gpio/gpiolib.c       |   45 -------------------------------------------
>  3 files changed, 129 deletions(-)
>
> Index: linux-2.6-tip/arch/arm/mach-ep93xx/gpio.c
> ===================================================================

I suggested an alternative patch for the ep93xx last time round which
keeps the information that the pin is configured as an interrupt and
tidies the code a bit (moves the newline to the first seq_printf). My
patch is available here:
http://lists-archives.org/linux-kernel/27439434-arm-ep93xx-kill-another-instance-of-broken-irq_desc-fiddling.html

Could we merge that instead please.

Thanks,
~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751 
Fax:   +64 3 3779135			  USA 1800 261 2934

