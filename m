Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab2HLXe2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 19:34:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64210 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab2HLXe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 19:34:26 -0400
Message-ID: <50283D7A.4090309@gmail.com>
Date: Mon, 13 Aug 2012 09:34:18 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@googlemail.com>
CC: linux-fbdev@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 03/11] fblog: new framebuffer kernel log dummy driver
References: <1344783205-2384-1-git-send-email-dh.herrmann@googlemail.com> <1344783205-2384-4-git-send-email-dh.herrmann@googlemail.com>
In-Reply-To: <1344783205-2384-4-git-send-email-dh.herrmann@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/08/12 00:53, David Herrmann wrote:
> Fblog displays all kernel log messages on all connected framebuffers. It
> replaces fbcon when CONFIG_VT=n is selected. Its main purpose is to debug
> boot problems by displaying the whole boot log on the screen. This patch
> provides the first dummy module-init/deinit functions.
> 
> As it uses all the font and fb functions I placed it in
> drivers/video/console. However, this means that we need to move the check
> for CONFIG_VT in Makefile/Kconfig from drivers/video into
> drivers/video/console as fblog does not depend on CONFIG_VT.
> 
> Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>

Hi David,

Couple of comments below.

~Ryan

>  config VGA_CONSOLE
>  	bool "VGA text console" if EXPERT || !X86
> -	depends on !4xx && !8xx && !SPARC && !M68K && !PARISC && !FRV && !SUPERH && !BLACKFIN && !AVR32 && !MN10300 && (!ARM || ARCH_FOOTBRIDGE || ARCH_INTEGRATOR || ARCH_NETWINDER)
> +	depends on VT && !4xx && !8xx && !SPARC && !M68K && !PARISC && !FRV && !SUPERH && !BLACKFIN && !AVR32 && !MN10300 && (!ARM || ARCH_FOOTBRIDGE || ARCH_INTEGRATOR || ARCH_NETWINDER)
>  	default y
>  	help
>  	  Saying Y here will allow you to use Linux in text mode through a
> @@ -45,7 +45,7 @@ config VGACON_SOFT_SCROLLBACK_SIZE
>  	 screenfuls of scrollback buffer

You could just place all of the CONFIG_VT options inside an if VT and
then the new fblog options in the else case rather than modifying all of
the (already overly long) depends statements.

> +config FBLOG
> +	tristate "Framebuffer Kernel Log Driver"
> +	depends on !VT && FB
> +	default n

Default n is not required, all options are default n unless otherwise
specified. I don't think you need the dependency on FB either, since
this file should only get included if CONFIG_FB is set?

> +	help
> +	  This driver displays all kernel log messages on all connected
> +	  framebuffers. It is mutually exclusive with CONFIG_FRAMEBUFFER_CONSOLE
> +	  and CONFIG_VT. It was mainly created for debugging purposes when
> +	  CONFIG_VT is not selected but you still want kernel boot messages on
> +	  the screen.

Do command line options exist to specify screens to write the debug log
to? It might be a useful feature to have.

~Ryan

