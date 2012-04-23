Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab2DWLef (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 07:34:35 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49618 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab2DWLed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 07:34:33 -0400
Date: Mon, 23 Apr 2012 12:34:25 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Jonas Aberg <jonas.aberg@stericsson.com>,
        Philippe LANGLAIS <philippe.langlais@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 5/9 v2] gpio/nomadik: use ioremap() instead of static
	mappings
Message-ID: <20120423113425.GN24211@n2100.arm.linux.org.uk>
References: <1335180632-21381-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335180632-21381-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 01:30:32PM +0200, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> We were using a custom io_p2v() (physical-to-virtual) translation
> macro, but it's fully possible to just ioremap() this memory
> now, so skip use of static addresses altogether.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/gpio/gpio-nomadik.c |   14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-nomadik.c b/drivers/gpio/gpio-nomadik.c
> index 7b45d88..bddc3dd 100644
> --- a/drivers/gpio/gpio-nomadik.c
> +++ b/drivers/gpio/gpio-nomadik.c
> @@ -28,7 +28,6 @@
>  
>  #include <plat/pincfg.h>
>  #include <plat/gpio-nomadik.h>
> -#include <mach/hardware.h>
>  #include <asm/gpio.h>

While you're here, please replace this with linux/gpio.h - which will give
us one less direct dependency on asm/ or mach/ includes from drivers.
