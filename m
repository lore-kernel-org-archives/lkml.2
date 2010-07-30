Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301Ab0G3Svb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:51:31 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52150 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759801Ab0G3SvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 14:51:11 -0400
Date: Fri, 30 Jul 2010 20:51:06 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
        Nicolas Pitre <nico@marvell.com>, linux-kernel@vger.kernel.org,
        Julia Lawall <julia@diku.dk>, Tejun Heo <tj@kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] MTD: pxa2xx: move pxa2xx_flash_probe to .devinit.text
Message-ID: <20100730185106.GA25446@pengutronix.de>
References: <1280504530-31737-1-git-send-email-u.kleine-koenig@pengutronix.de> <4C52F6C1.5090207@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4C52F6C1.5090207@mvista.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 30, 2010 at 07:58:57PM +0400, Sergei Shtylyov wrote:
> Uwe Kleine-König wrote:
>
>> This fixes the following warning by modpost:
>
>> 	WARNING: vmlinux.o(.data+0x15018): Section mismatch in reference from the variable pxa2xx_flash_driver to the function .init.text:pxa2xx_flash_probe()
>> 	The variable pxa2xx_flash_driver references
>> 	the function __init pxa2xx_flash_probe()
>> 	If the reference is valid then annotate the
>> 	variable with __init* or __refdata (see linux/init.h) or name the variable:
>> 	*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,
>
>> I choosed to do this instead of using platform_driver_probe as the remove
>
>    s/choosed/chose/
oh right, thanks.

>> function uses __devexit.
>
>    Perhaps remove() method should have been fixed instead -- I doubt that 
> this is a hotplug device.
Actually I don't care much.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
