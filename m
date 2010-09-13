Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab0IMUQ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 16:16:26 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50329 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754804Ab0IMUPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 16:15:17 -0400
Date: Mon, 13 Sep 2010 21:36:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        sparclinux@vger.kernel.org
Subject: Re: [PATCH 18/25] drivers/serial/suncore.c: Use static const char
 arrays
Message-ID: <20100913213613.223e10a5@lxorguk.ukuu.org.uk>
In-Reply-To: <0ab674aa32a5fcc364982c78efdf44864a61523b.1284406639.git.joe@perches.com>
References: <cover.1284406638.git.joe@perches.com>
	<0ab674aa32a5fcc364982c78efdf44864a61523b.1284406639.git.joe@perches.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Sep 2010 12:47:56 -0700
Joe Perches <joe@perches.com> wrote:

> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/serial/suncore.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/serial/suncore.c b/drivers/serial/suncore.c
> index 6381a02..f2a5b54 100644
> --- a/drivers/serial/suncore.c
> +++ b/drivers/serial/suncore.c
> @@ -84,8 +84,8 @@ EXPORT_SYMBOL(sunserial_console_match);
>  
>  void sunserial_console_termios(struct console *con, struct device_node *uart_dp)
>  {
> +	char mode_prop[sizeof("ttyX-mode")];
>  	const char *mode, *s;
> -	char mode_prop[] = "ttyX-mode";
>  	int baud, bits, stop, cflag;
>  	char parity;
>  
> @@ -106,7 +106,7 @@ void sunserial_console_termios(struct console *con, struct device_node *uart_dp)
>  		if (of_console_options)
>  			c = *of_console_options;
>  
> -		mode_prop[3] = c;
> +		sprintf(mode_prop, "tty%c-mode", c);

Whats the point of all this. It's trivial code being replaced by
something complicated, harder to understand and much slower ?
