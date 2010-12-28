Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab0L1QRG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 11:17:06 -0500
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:60849 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751991Ab0L1QRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 11:17:04 -0500
Date: Tue, 28 Dec 2010 18:16:57 +0200
From: Felipe Balbi <balbi@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, David Brownell <david-b@pacbell.net>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC/PATCH 1/2] mfd: twl6030-irq: move to threaded_irq
Message-ID: <20101228161657.GF2239@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1293544790-793-1-git-send-email-balbi@ti.com>
 <1293544790-793-2-git-send-email-balbi@ti.com>
 <20101228154617.GC14860@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20101228154617.GC14860@sirena.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Dec 28, 2010 at 03:46:17PM +0000, Mark Brown wrote:
>On Tue, Dec 28, 2010 at 03:59:49PM +0200, Felipe Balbi wrote:
>
>> +	disable_irq_nosync(irq);
>
>You shouldn't need this any more; the driver used to be faffing around
>with this because it wasn't using genirq for this in the past.
>
>> +	for (i = 0; sts.int_sts; sts.int_sts >>= 1, i++) {
>> +		local_irq_disable();
>
>Simiarly here as far as I know; the original code predates genirq
>support for this so is doing some hairy stuff that is no longer
>required and may actually be harmful.

Aa, true. Forgot that one.

>What I'd expect to see from a conversion like this would be that most of
>the locking/IRQ management stuff would be dropped and the bus_lock() and
>bus_sync_unlock() operations would be implemented.

I'll look into it, thanks.

-- 
balbi
