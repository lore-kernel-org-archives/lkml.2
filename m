Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639Ab1FGH0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 03:26:23 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33864 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471Ab1FGH0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 03:26:22 -0400
Date: Tue, 7 Jun 2011 09:26:17 +0200
From: Borislav Petkov <bp@alien8.de>
To: Greg KH <greg@kroah.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Antony Pavlov <antony@niisi.msk.ru>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] 8250_pci: Fix build warning
Message-ID: <20110607072617.GB21263@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, Greg KH <greg@kroah.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Antony Pavlov <antony@niisi.msk.ru>,
	Greg Kroah-Hartman <gregkh@suse.de>
References: <1306749174-31216-1-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1306749174-31216-1-git-send-email-bp@alien8.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Greg,

can you please pick this one up - warning is still present in -rc2 so it
looks like no one else fixed it yet :).

Thanks.

On Mon, May 30, 2011 at 11:52:54AM +0200, Borislav Petkov wrote:
> Fix
> 
> drivers/tty/serial/8250_pci.c:1457: warning: initialization from incompatible pointer type
> 
> by constifying the serial board :).
> 
> Cc: Antony Pavlov <antony@niisi.msk.ru>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Borislav Petkov <bp@alien8.de>
> ---
>  drivers/tty/serial/8250_pci.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/tty/serial/8250_pci.c b/drivers/tty/serial/8250_pci.c
> index 4b4968a..c9c9e6f 100644
> --- a/drivers/tty/serial/8250_pci.c
> +++ b/drivers/tty/serial/8250_pci.c
> @@ -973,8 +973,8 @@ ce4100_serial_setup(struct serial_private *priv,
>  
>  static int
>  pci_omegapci_setup(struct serial_private *priv,
> -		      struct pciserial_board *board,
> -		      struct uart_port *port, int idx)
> +		   const struct pciserial_board *board,
> +		   struct uart_port *port, int idx)
>  {
>  	return setup_port(priv, port, 2, idx * 8, 0);
>  }
> -- 
> 1.7.5.rc1.16.g9db1
> 
> 

-- 
Regards/Gruss,
    Boris.
