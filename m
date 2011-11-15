Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab1KOJJX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 04:09:23 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:9418 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753615Ab1KOJJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 04:09:21 -0500
Message-ID: <4EC22A68.6020400@atmel.com>
Date: Tue, 15 Nov 2011 10:01:28 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111031 Thunderbird/7.0.1
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: gregkh@suse.de, linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        jirislaby@gmail.com, Alan Cox <alan@linux.intel.com>,
        Viktar Palstsiuk <viktar.palstsiuk@promwad.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCH 02/10] TTY: serial, cleanup atmel_set_ldisc
References: <1320870831-23778-1-git-send-email-jslaby@suse.cz> <1320870831-23778-2-git-send-email-jslaby@suse.cz>
In-Reply-To: <1320870831-23778-2-git-send-email-jslaby@suse.cz>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2011 09:33 PM, Jiri Slaby :
> Current ldisc number is passed as a paramneter -- no need to dig it
> out of the tty or ldisc. So switch PPS check to that.
> 
> No tty callback can be called with port->line higher than TTY driver
> num. So remove the check.
> 
> This removes some port.tty users.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Alan Cox <alan@linux.intel.com>
> Cc: Viktar Palstsiuk <viktar.palstsiuk@promwad.com>
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> ---
>  drivers/tty/serial/atmel_serial.c |    7 +------
>  1 files changed, 1 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
> index 4a0f86f..6b844d4 100644
> --- a/drivers/tty/serial/atmel_serial.c
> +++ b/drivers/tty/serial/atmel_serial.c
> @@ -1256,12 +1256,7 @@ static void atmel_set_termios(struct uart_port *port, struct ktermios *termios,
>  
>  static void atmel_set_ldisc(struct uart_port *port, int new)
>  {
> -	int line = port->line;
> -
> -	if (line >= port->state->port.tty->driver->num)
> -		return;
> -
> -	if (port->state->port.tty->ldisc->ops->num == N_PPS) {
> +	if (new == N_PPS) {
>  		port->flags |= UPF_HARDPPS_CD;
>  		atmel_enable_ms(port);
>  	} else {


-- 
Nicolas Ferre
