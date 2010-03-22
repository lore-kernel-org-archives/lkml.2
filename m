Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294Ab0CVI7L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 04:59:11 -0400
Received: from cantor.suse.de ([195.135.220.2]:43784 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753890Ab0CVI7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 04:59:09 -0400
Date: Mon, 22 Mar 2010 09:59:07 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>,
       Nicu Pavel <npavel@ituner.com>, Oliver Neukum <oliver@neukum.org>,
       Jaya Kumar <jayakumar.lkml@gmail.com>,
       Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH v2 3/6] hid: add backlight support to PicoLCD device
In-Reply-To: <20100320170619.4ae99546@neptune.home>
Message-ID: <alpine.LNX.2.00.1003220957390.18642@pobox.suse.cz>
References: <20100320170014.440959a8@neptune.home> <20100320170619.4ae99546@neptune.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Mar 2010, Bruno Prémont wrote:

> Add backlight support to PicoLCD device.
> 
> Backlight support depends on backlight class and is only being
> compiled if backlight class has been selected.
> 
> Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
> ---
>  drivers/hid/Kconfig       |    2 +-
>  drivers/hid/hid-picolcd.c |  134 ++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 134 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
> index a474bcd..5ec3cb7 100644
> --- a/drivers/hid/Kconfig
> +++ b/drivers/hid/Kconfig
> @@ -243,8 +243,8 @@ config HID_PICOLCD
>  	  - Keypad
>  	  - Switching between Firmware and Flash mode
>  	  - Framebuffer for monochrome 256x64 display
> +	  - Backlight control    (needs CONFIG_BACKLIGHT_CLASS_DEVICE)

Wouldn't it be better to have Kconfig rules actually resolve the 
dependency?

I don't see any issue with HID_PICOLCD directly selecting 
BACKLIGHT_CLASS_DEVICE. Or you can do a separate sub-option for that, if 
you really want to avoid the direct dependency of the whole driver.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
