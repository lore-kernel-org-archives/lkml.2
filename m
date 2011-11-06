Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab1KFSdl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 13:33:41 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45309 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab1KFSdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 13:33:40 -0500
Date: Sun, 6 Nov 2011 11:33:36 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Hartmut Knaack <knaack.h@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] gpiolib: output basic details and consolidate gpio
 device drivers
Message-ID: <20111106183336.GA2546@ponder.secretlab.ca>
References: <4EB5AA57.7070008@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB5AA57.7070008@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 05, 2011 at 10:27:51PM +0100, Hartmut Knaack wrote:
> This patch adds a kernel message, containing GPIO range and device name on successful device registration.
> 
> Signed-off-by: Hartmut Knaack <knaack.h@gmx.de>
> -------------------------------------------------------------

For next time; the divider between commit text and patch must be
exactly 3 '-' characters long, no more, no less.  Otherwise the tools
don't handle it properly.

> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index a971e3d..d919ac6 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -1088,6 +1088,10 @@ unlock:
>  	status = gpiochip_export(chip);
>  	if (status)
>  		goto fail;
> +	

Whitespace error.

Otherwise looks good.  I'm picking it up and squashing it together
with the second patch.

> +	pr_info("gpiochip_add: registered GPIOs %d to %d on device: %s\n",
> +		chip->base, chip->base + chip->ngpio - 1,
> +		chip->label ? : "generic");
>  
>  	return 0;
>  fail:
> 
