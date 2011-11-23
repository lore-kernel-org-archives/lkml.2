Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946Ab1KWMK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 07:10:59 -0500
Received: from smtp15.mail.ru ([94.100.176.133]:53818 "EHLO smtp15.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754475Ab1KWMK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 07:10:57 -0500
Date: Wed, 23 Nov 2011 16:10:51 +0400
From: Dmitry Artamonow <mad_soft@inbox.ru>
To: Marc Vertes <marc.vertes@sigfox.com>
Cc: w.sang@pengutronix.de, wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, HaraldWelte@viatech.com,
        broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH RFC] watchdog: add a new driver for VIA chipsets
Message-ID: <20111123121051.GA18320@rainbow>
References: <4ecb84b9.48rmEWqC3D6x18iE%marc.vertes@sigfox.com>
 <20111122112212.GD2734@pengutronix.de>
 <4ecbd66c.8a87vIwdu0Z+quuZ%marc.vertes@sigfox.com>
 <20111122173029.GA14349@pengutronix.de>
 <4ecbe56d.0B7WEVDKkK1s88MJ%marc.vertes@sigfox.com>
 <4ecbf011.dZASXe6D5kH4Uxve%marc.vertes@sigfox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ecbf011.dZASXe6D5kH4Uxve%marc.vertes@sigfox.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19:55 Tue 22 Nov     , Marc Vertes wrote:
> Add a new driver for the hardware watchdog timer on VIA chipsets.
> This driver uses the new watchdog framework.
> Tested on a Artigo A1100, VX855 chipset.
> 
> Signed-off-by: Marc Vertes <marc.vertes@sigfox.com>
> ---

[ .... ]

> +obj-$(CONFIG_VIA_WDT) += via_wdt.o

"via_wdt" seems to be a too generic name. What if someone will want to
write driver for some incompatible watchdog also made by VIA?
Maybe it's worth to use something more specific - say, "via_vx8xx_wdt"?


> + *
> + * The only way to activate the watchdog timer or to set its period is
> + * through BIOS setup.
> + */

Why is to rely on BIOS setup? Is there really no information on what
registers to write to start watchdog? Or you was just lazy to find it?
It took me less than a minute to google up a datasheet[1] on VX800/VX820
and it seems to have all needed information to implement proper start()
and stop() functions. I suppose info on watchdog registers should be
applicable to VX855 as well - but it's better to check on your hardware
anyway.

[1] http://linux.via.com.tw/support/beginDownload.action?eleid=161&fid=241

-- 
Best regards,
Dmitry "MAD" Artamonow

