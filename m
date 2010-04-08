Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758683Ab0DHMm6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 08:42:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45323 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757876Ab0DHMmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 08:42:55 -0400
Date: Thu, 8 Apr 2010 14:42:47 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       rvinyard@cs.nmsu.edu
Subject: Re: [PATCH mmotm] hid-picolcd: depends on LCD_CLASS_DEVICE
In-Reply-To: <20100407203132.7fe2d0f1@neptune.home>
Message-ID: <alpine.LNX.2.00.1004081441460.8345@pobox.suse.cz>
References: <201004052336.o35NaeSE015814@imap1.linux-foundation.org> <20100405220414.9d90da83.randy.dunlap@oracle.com> <alpine.LNX.2.00.1004061038510.8345@pobox.suse.cz> <20100406105635.5384a087@pluto.restena.lu> <20100406082614.79aaf1c5.randy.dunlap@oracle.com>
 <20100406183535.7de3c628@neptune.home> <20100406095633.49ec957a.randy.dunlap@oracle.com> <20100406230434.1336c317@neptune.home> <20100407092010.4cd60ece.randy.dunlap@oracle.com> <20100407203132.7fe2d0f1@neptune.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Apr 2010, Bruno Prémont wrote:

> HID_PICOLCD should depend on LCD_CLASS_DEVICE, otherwise the
> build fails when HID_PICOLCD=y and LCD_CLASS_DEVICE=m:
> 
> hid-picolcd.c:(.text+0x84523f): undefined reference to `lcd_device_unregister'
> hid-picolcd.c:(.text+0x8478ab): undefined reference to `lcd_device_register'
> hid-picolcd.c:(.text+0x84c15f): undefined reference to `lcd_device_unregister'
> 
> Same applies to FB, BACKLIGHT_CLASS_DEVICE and LEDS_CLASS.
> 
> Add suboptions for those features to handle the deps on kbuild side
> and just check HID_PICOLCD_* in the code.
> 
> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
> ---
> 
> On Wed, 07 April 2010 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > All of these user-visible kconfig options need help text also...
> > 
> 
> Here is a better patch, with added documentation and stripped
> select clauses under HID_PICOLCD as they are handled by HID_PICOLCD_FB.
> 
> 
> 
> 
>  drivers/hid/Kconfig       |   53 +++++++++++++++++++++++++++++++++++++-------
>  drivers/hid/hid-picolcd.c |   40 +++++++++++++++++-----------------
>  2 files changed, 64 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
> index a2ecd83..782a34e 100644
> --- a/drivers/hid/Kconfig
> +++ b/drivers/hid/Kconfig
> @@ -265,11 +265,6 @@ config HID_PETALYNX
>  config HID_PICOLCD
>  	tristate "PicoLCD (graphic version)"
>  	depends on USB_HID
> -	select FB_DEFERRED_IO if FB
> -	select FB_SYS_FILLRECT if FB
> -	select FB_SYS_COPYAREA if FB
> -	select FB_SYS_IMAGEBLIT if FB
> -	select FB_SYS_FOPS if FB
>  	---help---
>  	  This provides support for Minibox PicoLCD devices, currently
>  	  only the graphical ones are supported.
> @@ -277,14 +272,54 @@ config HID_PICOLCD
>  	  This includes support for the following device features:
>  	  - Keypad
>  	  - Switching between Firmware and Flash mode
> -	  - Framebuffer for monochrome 256x64 display
> -	  - Backlight control         (needs CONFIG_BACKLIGHT_CLASS_DEVICE)
> -	  - Contrast control          (needs CONFIG_LCD_CLASS_DEVICE)
> -	  - General purpose outputs   (needs CONFIG_LEDS_CLASS)
>  	  - EEProm / Flash access     (via debugfs)
> +	  Features to selectively enable:
> +	  - Framebuffer for monochrome 256x64 display
> +	  - Backlight control
> +	  - Contrast control
> +	  - General purpose outputs
>  	  Features that are not (yet) supported:
>  	  - IR
>  
> +config HID_PICOLCD_FB
> +	bool "Framebuffer support"
> +	default !EMBEDDED
> +	depends on HID_PICOLCD
> +	depends on HID_PICOLCD=FB || FB=y
> +	select FB_DEFERRED_IO
> +	select FB_SYS_FILLRECT
> +	select FB_SYS_COPYAREA
> +	select FB_SYS_IMAGEBLIT
> +	select FB_SYS_FOPS

Could we perhaps also make the sub-choices for individual features 
availabel only if !EMBEDDED as well?

It's probably too much to ask for a single device during oldconfig run, 
for example ...

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
