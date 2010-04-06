Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265Ab0DFI4n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 04:56:43 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:50670 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab0DFI4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 04:56:37 -0400
Date: Tue, 6 Apr 2010 10:56:35 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       rvinyard@cs.nmsu.edu
Subject: Re: [PATCH mmotm] hid-picolcd: depends on LCD_CLASS_DEVICE
Message-ID: <20100406105635.5384a087@pluto.restena.lu>
In-Reply-To: <alpine.LNX.2.00.1004061038510.8345@pobox.suse.cz>
References: <201004052336.o35NaeSE015814@imap1.linux-foundation.org>
	<20100405220414.9d90da83.randy.dunlap@oracle.com>
	<alpine.LNX.2.00.1004061038510.8345@pobox.suse.cz>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.16.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Apr 2010 10:40:06 +0200 Jiri Kosina <jkosina@suse.cz> wrote:
> 
> [ adding Bruno to CC ]
> 
> On Mon, 5 Apr 2010, Randy Dunlap wrote:
> 
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > HID_PICOLCD should depend on LCD_CLASS_DEVICE, otherwise the
> > build fails when HID_PICOLCD=y and LCD_CLASS_DEVICE=m:
> > 
> > hid-picolcd.c:(.text+0x84523f): undefined reference to `lcd_device_unregister'
> > hid-picolcd.c:(.text+0x8478ab): undefined reference to `lcd_device_register'
> > hid-picolcd.c:(.text+0x84c15f): undefined reference to `lcd_device_unregister'

That is weird, the

#if defined(CONFIG_LCD_CLASS_DEVICE) || defined(CONFIG_LCD_CLASS_DEVICE_MODULE)
  feature support code
#else
  empty stubs
#endif

blocks should have prevented LCD_CLASS support from being built if it
was not enabled in configuration.

Do you have the .config matching your build?

When I did my test-build with LCD support enabled/disabled I didn't get
any linker errors as those mentioned above.


Thanks,
Bruno


> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > ---
> >  drivers/hid/Kconfig |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > --- mmotm-2010-0405-1609.orig/drivers/hid/Kconfig
> > +++ mmotm-2010-0405-1609/drivers/hid/Kconfig
> > @@ -265,6 +265,7 @@ config HID_PETALYNX
> >  config HID_PICOLCD
> >  	tristate "PicoLCD (graphic version)"
> >  	depends on USB_HID
> > +	depends on LCD_CLASS_DEVICE
> >  	select FB_DEFERRED_IO if FB
> >  	select FB_SYS_FILLRECT if FB
> >  	select FB_SYS_COPYAREA if FB
> 
> Thanks Randy. We'll have to take care of the other dependencies as well 
> though (CONFIG_LCD_CLASS_DEVICE, CONFIG_LEDS_CLASS).
> 
