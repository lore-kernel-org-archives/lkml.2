Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab1LMA4s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 19:56:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35923 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753890Ab1LMA4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 19:56:47 -0500
Date: Mon, 12 Dec 2011 16:54:44 -0800
From: Greg KH <gregkh@suse.de>
To: Michael Neuling <mikey@neuling.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
        sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH] serial: fix Kconfig for Freescale 16550
Message-ID: <20111213005444.GA27190@suse.de>
References: <7963.1323736263@neuling.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7963.1323736263@neuling.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 11:31:03AM +1100, Michael Neuling wrote:
> next-20111212 breaks with linking a pmac32_defconfig with:
>   drivers/built-in.o: In function `fsl8250_handle_irq':
>   (.text+0x7ba74): undefined reference to `serial8250_modem_status'
>   drivers/built-in.o: In function `fsl8250_handle_irq':
>   (.text+0x7baa4): undefined reference to `serial8250_tx_chars'
>   drivers/built-in.o: In function `fsl8250_handle_irq':
>   (.text+0x7bab4): undefined reference to `serial8250_rx_chars'
> 
> Caused by:
>   9deaa53 serial: add irq handler for Freescale 16550 errata.
> 
> pmac32_defconfig results in SERIAL_8250_FSL=y but SERIAL_8250=m so
> 8250_fsl.c doesn't link properly.  
> 
> This explicitly makes SERIAL_8250_FSL depends on SERIAL_8250=y. 
> 
> Signed-off-by: Michael Neuling <mikey@neuling.org>
> ---
> I'm not sure this is the right fix as it seems like a Kconfig bug.  
> 
> diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
> index a1d55c3..c9046de 100644
> --- a/drivers/tty/serial/Kconfig
> +++ b/drivers/tty/serial/Kconfig
> @@ -99,7 +99,7 @@ config SERIAL_8250_PNP
>  
>  config SERIAL_8250_FSL
>  	bool
> -	depends on SERIAL_8250 && PPC
> +	depends on SERIAL_8250=y && PPC

Then you can't select SERIAL_8250 as a module at all, right?  Perhaps
you should allow SERIAL_8250_FSL to be a module as well here?  So
changing the bool to a tristate should be the correct option?  Can you
try that?

greg k-h
