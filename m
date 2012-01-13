Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759384Ab2AMWb0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 17:31:26 -0500
Received: from lunge.queued.net ([173.255.254.236]:59912 "EHLO
	lunge.queued.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038Ab2AMWbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 17:31:25 -0500
Date: Fri, 13 Jan 2012 14:31:22 -0800
From: Andres Salomon <dilinger@queued.net>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        x86 maintainers <x86@kernel.org>, Chris Ball <cjb@laptop.org>,
        Jon Nettleton <jon.nettleton@gmail.com>, dsd@laptop.org
Subject: Re: [PATCH -next] olpc: fix olpc-xo1-sci.c build when INPUT=m
Message-ID: <20120113143122.3277e7a1@queued.net>
In-Reply-To: <4F10B169.4070807@xenotime.net>
References: <20120110164454.b595335a42321c80fba56ea7@canb.auug.org.au>
	<4F0CADDB.5010303@xenotime.net>
	<4F10B169.4070807@xenotime.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jan 2012 14:34:17 -0800
Randy Dunlap <rdunlap@xenotime.net> wrote:

> On 01/10/2012 01:30 PM, Randy Dunlap wrote:
> > From: Randy Dunlap <rdunlap@xenotime.net>
> > 
> > Fix build errors when CONFIG_INPUT=m.
> > This is not pretty, but all of the OLPC kconfig options
> > are bool instead of tristate.

How about 'select INPUT' instead?

Cc'ing dsd, as he's the one who worked on the SCI code.  I'm still
annoyed that this stuff is bool rather than tristate.. Might be worth
spending some time allowing it to be modular, if we can figure out a
non-racy solution.


> 
> 
> ping.
> 
> This patch is still needed in linux-next (20120113).
> 
> 
> > arch/x86/built-in.o: In function `send_lid_state':
> > olpc-xo1-sci.c:(.text+0x1d323): undefined reference to `input_event'
> > olpc-xo1-sci.c:(.text+0x1d338): undefined reference to `input_event'
> > arch/x86/built-in.o: In function `free_ebook_switch':
> > olpc-xo1-sci.c:(.text+0x1d529): undefined reference to
> > `input_unregister_device' olpc-xo1-sci.c:(.text+0x1d533): undefined
> > reference to `input_free_device' arch/x86/built-in.o: In function
> > `free_power_button': olpc-xo1-sci.c:(.text+0x1d549): undefined
> > reference to `input_unregister_device'
> > olpc-xo1-sci.c:(.text+0x1d553): undefined reference to
> > `input_free_device' arch/x86/built-in.o: In function
> > `send_ebook_state': olpc-xo1-sci.c:(.text+0x1d632): undefined
> > reference to `input_event' olpc-xo1-sci.c:(.text+0x1d647):
> > undefined reference to `input_event' arch/x86/built-in.o: In
> > function `xo1_sci_intr': olpc-xo1-sci.c:(.text+0x1d78e): undefined
> > reference to `input_event' olpc-xo1-sci.c:(.text+0x1d7a3):
> > undefined reference to `input_event'
> > olpc-xo1-sci.c:(.text+0x1d7be): undefined reference to
> > `input_event' arch/x86/built-in.o:olpc-xo1-sci.c:(.text+0x1d7d3):
> > more undefined references to `input_event' follow
> > arch/x86/built-in.o: In function `free_lid_switch':
> > olpc-xo1-sci.c:(.text+0x1d7fd): undefined reference to
> > `input_unregister_device' olpc-xo1-sci.c:(.text+0x1d807): undefined
> > reference to `input_free_device' arch/x86/built-in.o: In function
> > `setup_lid_switch': olpc-xo1-sci.c:(.devinit.text+0x155): undefined
> > reference to `input_allocate_device'
> > olpc-xo1-sci.c:(.devinit.text+0x1a4): undefined reference to
> > `input_register_device' olpc-xo1-sci.c:(.devinit.text+0x1ce):
> > undefined reference to `input_unregister_device'
> > olpc-xo1-sci.c:(.devinit.text+0x1d8): undefined reference to
> > `input_free_device' arch/x86/built-in.o: In function
> > `xo1_sci_probe': olpc-xo1-sci.c:(.devinit.text+0x235): undefined
> > reference to `input_allocate_device'
> > olpc-xo1-sci.c:(.devinit.text+0x285): undefined reference to
> > `input_register_device' olpc-xo1-sci.c:(.devinit.text+0x299):
> > undefined reference to `input_free_device'
> > olpc-xo1-sci.c:(.devinit.text+0x2e1): undefined reference to
> > `input_register_device' olpc-xo1-sci.c:(.devinit.text+0x2f5):
> > undefined reference to `input_free_device'
> > olpc-xo1-sci.c:(.devinit.text+0x54c): undefined reference to
> > `input_allocate_device'
> > 
> > Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> > Cc:	Andres Salomon <dilinger@queued.net>
> > Cc:	Chris Ball <cjb@laptop.org>
> > Cc:	Jon Nettleton <jon.nettleton@gmail.com>
> > ---
> >  arch/x86/Kconfig |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > --- linux-next-20120110.orig/arch/x86/Kconfig
> > +++ linux-next-20120110/arch/x86/Kconfig
> > @@ -2132,6 +2132,7 @@ config OLPC_XO1_RTC
> >  config OLPC_XO1_SCI
> >  	bool "OLPC XO-1 SCI extras"
> >  	depends on OLPC && OLPC_XO1_PM
> > +	depends on INPUT=y
> >  	select POWER_SUPPLY
> >  	select GPIO_CS5535
> >  	select MFD_CORE
> > 
> 
> 
