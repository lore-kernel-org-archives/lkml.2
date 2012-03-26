Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519Ab2CZGaJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 02:30:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44660 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283Ab2CZGaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 02:30:05 -0400
Date: Sun, 25 Mar 2012 23:29:59 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 08/11] input/amijoy: Add missing platform check
Message-ID: <20120326062959.GB1054@core.coreip.homeip.net>
References: <1332323515-7314-1-git-send-email-geert@linux-m68k.org>
 <1332323515-7314-8-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332323515-7314-8-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 10:51:52AM +0100, Geert Uytterhoeven wrote:
> On multi-platform kernels, the Amiga joystick driver may be initialized
> when running on Amiga only. Else it may crash later.
> Fortunately this driver is almost always compiled as a module (to avoid
> conflicts with the mouse driver), so it needs an explicit insmod to
> trigger a crash.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: linux-input@vger.kernel.org

Applied, thanks Geert.

> ---
>  drivers/input/joystick/amijoy.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/input/joystick/amijoy.c b/drivers/input/joystick/amijoy.c
> index 0bc8620..3aa93bf 100644
> --- a/drivers/input/joystick/amijoy.c
> +++ b/drivers/input/joystick/amijoy.c
> @@ -108,6 +108,9 @@ static int __init amijoy_init(void)
>  	int i, j;
>  	int err;
>  
> +	if (!MACH_IS_AMIGA)
> +		return -ENODEV;
> +
>  	for (i = 0; i < 2; i++) {
>  		if (!amijoy[i])
>  			continue;
> -- 
> 1.7.0.4
> 

-- 
Dmitry
