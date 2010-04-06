Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879Ab0DFIkM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 04:40:12 -0400
Received: from cantor.suse.de ([195.135.220.2]:43506 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157Ab0DFIkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 04:40:09 -0400
Date: Tue, 6 Apr 2010 10:40:06 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, rvinyard@cs.nmsu.edu,
       =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Subject: Re: [PATCH mmotm] hid-picolcd: depends on LCD_CLASS_DEVICE
In-Reply-To: <20100405220414.9d90da83.randy.dunlap@oracle.com>
Message-ID: <alpine.LNX.2.00.1004061038510.8345@pobox.suse.cz>
References: <201004052336.o35NaeSE015814@imap1.linux-foundation.org> <20100405220414.9d90da83.randy.dunlap@oracle.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ adding Bruno to CC ]

On Mon, 5 Apr 2010, Randy Dunlap wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> HID_PICOLCD should depend on LCD_CLASS_DEVICE, otherwise the
> build fails when HID_PICOLCD=y and LCD_CLASS_DEVICE=m:
> 
> hid-picolcd.c:(.text+0x84523f): undefined reference to `lcd_device_unregister'
> hid-picolcd.c:(.text+0x8478ab): undefined reference to `lcd_device_register'
> hid-picolcd.c:(.text+0x84c15f): undefined reference to `lcd_device_unregister'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/hid/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- mmotm-2010-0405-1609.orig/drivers/hid/Kconfig
> +++ mmotm-2010-0405-1609/drivers/hid/Kconfig
> @@ -265,6 +265,7 @@ config HID_PETALYNX
>  config HID_PICOLCD
>  	tristate "PicoLCD (graphic version)"
>  	depends on USB_HID
> +	depends on LCD_CLASS_DEVICE
>  	select FB_DEFERRED_IO if FB
>  	select FB_SYS_FILLRECT if FB
>  	select FB_SYS_COPYAREA if FB

Thanks Randy. We'll have to take care of the other dependencies as well 
though (CONFIG_LCD_CLASS_DEVICE, CONFIG_LEDS_CLASS).

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
