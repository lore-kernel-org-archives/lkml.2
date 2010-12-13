Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab0LMLie (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 06:38:34 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52952 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab0LMLic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 06:38:32 -0500
Date: Mon, 13 Dec 2010 12:38:30 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Liu Ying <liu.y.victor@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, Zhang Lily-R58066 <r58066@freescale.com>,
        Arnaud Patard <arnaud.patard@rtp-net.org>
Subject: Re: [PATCH 5/9] Add i.MX5 framebuffer driver
Message-ID: <20101213113830.GE6017@pengutronix.de>
References: <1291902441-24712-1-git-send-email-s.hauer@pengutronix.de> <1291902441-24712-6-git-send-email-s.hauer@pengutronix.de> <AANLkTikZowDCK4JPiCyEou1ekRuYA1qGnKrBPT5dXB+8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikZowDCK4JPiCyEou1ekRuYA1qGnKrBPT5dXB+8@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:24:05 up 163 days,  2:34, 47 users,  load average: 3.47, 3.29,
	2.32
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 12, 2010 at 02:13:40PM +0800, Liu Ying wrote:
> Hello, Sascha,
> 
> I have following comments to this patch:
> 1) Please modify the commit message, as IPUv3 is not embedded in i.MX50 SoC.

ok.

> 2) ADC is not supported yet in the framebuffer driver, so please
> modify this comment:
>    > + * Framebuffer Framebuffer Driver for SDC and ADC.

ok.

> 3) 'ipu_dp_set_window_pos()' is called only once in
> imx_ipu_fb_set_par_overlay(). So, the framebuffer driver doesn't
> support to change the overlay framebuffer position. Need a
> mechanism/interface for users to change the overlay framebuffer
> position.

Yes. The overlay support is currently only present in the driver because
I didn't want to break it in general. There is no generic overlay API in
the kernel and I didn't want to invent the n+1 API. Currently the
possible use cases of the overlay support are not clear to me. Number
one use case would probably be to display video output, but the
corresponding driver would be a v4l2 driver, so in this case we would
only need an in-kernel API.
Anyway, I have not the resources to implement complete overlay support.
So either we keep it like it is and it more has an example character
or we remove it completely from the driver for now.

> 4) Need to make sure the framebuffer on DP-FG is blanked before the
> framebuffer on DP-BG is blanked. Meanwhile, the framebuffer on DP-FG
> should be unblanked after the framebuffer on DP-BG is unblanked
> 5) Need to check the framebuffer on DP-FG doesn't run out of the range
> of the framebuffer on DP-BG.

I tend to remove the overlay support.

> 6) I prefer to find the video mode in modedb first, and if we cannot
> find the video mode in common video mode data base, we can find a
> video mode in custom video mode data base which is defined in platform
> data. In this way, we don't need to export common modefb.

I exported the modedb to be able to show the different modes under
/sys/class/graphics/fb0/modes and to set it with
/sys/class/graphics/fb0/mode. If you want this there is no way around
exporting it. The ioctl interface for mode setting is independent of the
specific modes anyway.

BTW please make comments specific to specific code inline.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
