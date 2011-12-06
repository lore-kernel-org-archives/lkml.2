Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933363Ab1LFLgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 06:36:55 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49557 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933207Ab1LFLgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 06:36:52 -0500
Date: Tue, 6 Dec 2011 11:37:41 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sonic Zhang <sonic.adi@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, <linux-serial@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: Re: [PATCH] serial: bfin-sport-uart: Add tty ASYNC_CTS_FLOW flag to
 do CTS flow control.
Message-ID: <20111206113741.6f375673@lxorguk.ukuu.org.uk>
In-Reply-To: <1323159754-15687-1-git-send-email-sonic.adi@gmail.com>
References: <1323159754-15687-1-git-send-email-sonic.adi@gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Dec 2011 16:22:34 +0800
Sonic Zhang <sonic.adi@gmail.com> wrote:

> From: Sonic Zhang <sonic.zhang@analog.com>
> 
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> ---
>  drivers/tty/serial/bfin_sport_uart.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/tty/serial/bfin_sport_uart.c b/drivers/tty/serial/bfin_sport_uart.c
> index f650526..7fbc3a0 100644
> --- a/drivers/tty/serial/bfin_sport_uart.c
> +++ b/drivers/tty/serial/bfin_sport_uart.c
> @@ -810,8 +810,10 @@ static int __devinit sport_uart_probe(struct platform_device *pdev)
>  		res = platform_get_resource(pdev, IORESOURCE_IO, 0);
>  		if (res == NULL)
>  			sport->cts_pin = -1;
> -		else
> +		else {
>  			sport->cts_pin = res->start;
> +			sport->port.flags |= ASYNC_CTS_FLOW;
> +		}
>  
>  		res = platform_get_resource(pdev, IORESOURCE_IO, 1);
>  		if (res == NULLA

Acked-by: Alan Cox <alan@linux.intel.com>
