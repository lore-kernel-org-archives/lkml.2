Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913Ab1GYVI5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 17:08:57 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54299 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012Ab1GYVIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 17:08:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        devel@driverdev.osuosl.org
Subject: Re: GMA500: ERROR: "__bad_udelay" undefined!
Date: Mon, 25 Jul 2011 23:08:42 +0200
Message-ID: <62472696.BtqhiR95vr@wuerfel>
User-Agent: KMail/4.6.0 (Linux/3.0.0-rc1nosema+; KDE/4.6.90; x86_64; ; )
In-Reply-To: <4E2CC6CC.5020204@gmail.com>
References: <alpine.LNX.2.00.1107242327030.7103@swampdragon.chaosbits.net> <4E2CC55B.5010307@gmail.com> <4E2CC6CC.5020204@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ABXsAr+UDXcUSLgrPFq+blNuRjwhalRE+wX7H3cFgbF
 kJfgAb14LGBqz/9T56nORIMnb82U5ATd3sULa4jIbE3S9YSwtx
 fl6E/nemPPN1M/osSP7xZ7IqEZe5ooiQTnLnq/RUvHW94su+c0
 2HXFIlma6vnyZIiAn8UWkHoN0TK6tFLp8+FZrxrAAHuYQ2SDLk
 ZpCEdbH7qEtg4CTfrksHg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 July 2011 11:28:44 Ryan Mallon wrote:
> 
> diff --git a/drivers/staging/gma500/psb_intel_display.c b/drivers/staging/gma500/psb_intel_display.c
> index 4f47d09..09e378d 100644
> --- a/drivers/staging/gma500/psb_intel_display.c
> +++ b/drivers/staging/gma500/psb_intel_display.c
> @@ -331,7 +331,7 @@ static bool psb_intel_find_best_PLL(struct drm_crtc *crtc, int target,
>   void psb_intel_wait_for_vblank(struct drm_device *dev)
>   {
>         /* Wait for 20ms, i.e. one cycle at 50hz. */
> -       udelay(20000);
> +       mdelay(20);
>   }
> 
>   int psb_intel_pipe_set_base(struct drm_crtc *crtc,

A 20 ms busy wait is rather nasty. Can't this be replaced with a sleeping
wait (msleep)?

	Arnd
