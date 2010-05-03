Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab0ECI5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 04:57:22 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:25235 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751028Ab0ECI5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 04:57:20 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAFMr3ktbstD1/2dsb2JhbACdIHK5QQ6FBAQ
Date: Mon, 3 May 2010 10:57:19 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] watchdogs: fix several MODULE_PARM_DESC strings
Message-ID: <20100503085719.GA24325@infomag.iguana.be>
References: <20100501094615.06fc4972.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100501094615.06fc4972.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

> Fix MODULE_PARM_DESC() strings in several watchdog drivers.
> Some are simple as add a parenthesis.
> Others are problems from __stringify() being used on a
> variable name instead of a macro name, so the variable name
> is produced in the string instead of its build-time value.
> In these cases, create a macro for the value so that the
> module param description string is useful.
> 
> Only pc87413_wdt has been built (due to toolchains).
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Wim Van Sebroeck <wim@iguana.be>

Adding this one to the linux-2.6-watchdog-next tree.

> BTW, in ep93xx_wdt.c, I can't find where WATCHDOG_TIMEOUT is
> defined.  Can someone point me to it, please?
> (or does it not even build?)

I don't think it will build: WDT_TIMEOUT is the correct timeout macro.
I'll sent in a fix for this. Thanks!

> --- lnx-2634-rc6.orig/drivers/watchdog/pc87413_wdt.c
> +++ lnx-2634-rc6/drivers/watchdog/pc87413_wdt.c
> @@ -53,7 +53,9 @@
>  #define WDTO                0x11	/* Watchdog timeout register */
>  #define WDCFG               0x12	/* Watchdog config register */
>  
> -static int io = 0x2E;			/* Address used on Portwell Boards */
> +#define IO_DEFAULT	0x2E		/* Address used on Portwell Boards */
> +
> +static int io = IO_DEFAULT;
>  
>  static int timeout = DEFAULT_TIMEOUT;	/* timeout value */
>  static unsigned long timer_enabled;	/* is the timer enabled? */
> @@ -583,12 +585,12 @@ MODULE_LICENSE("GPL");
>  MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
>  
>  module_param(io, int, 0);
> -MODULE_PARM_DESC(io, MODNAME " I/O port (default: " __MODULE_STRING(io) ").");
> +MODULE_PARM_DESC(io, MODNAME " I/O port (default: " __MODULE_STRING(IO_DEFAULT) ").");

This one is changed to:
+MODULE_PARM_DESC(io, MODNAME " I/O port (default: "
+                                       __MODULE_STRING(IO_DEFAULT) ").");

Kind regards,
Wim.

