Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663Ab2BBXJ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 18:09:57 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:34995 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755272Ab2BBXJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 18:09:55 -0500
X-Sasl-enc: KMCUYEI4c3/7n3rgx7pUDqOd6vOnmmqRJ/TIrUKT/GhO 1328224194
Date: Thu, 2 Feb 2012 15:05:18 -0800
From: Greg KH <greg@kroah.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, alan@linux.intel.com,
        jirislaby@gmail.com
Subject: Re: [PATCH 3/5] TTY: use tty_standard_install
Message-ID: <20120202230518.GA18903@kroah.com>
References: <1327954472-26594-1-git-send-email-jslaby@suse.cz>
 <1327954472-26594-3-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327954472-26594-3-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 09:14:30PM +0100, Jiri Slaby wrote:
> Use the helper in the rest of the tty drivers. This is a simple
> replacement.

It would be, if you actually built this patch, as it is, it breaks :(

> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Acked-by: Alan Cox <alan@linux.intel.com>
> ---
>  drivers/isdn/capi/capi.c     |    9 +++------
>  drivers/misc/pti.c           |    6 +-----
>  drivers/mmc/card/sdio_uart.c |    9 +++------
>  drivers/tty/nozomi.c         |    8 ++------
>  4 files changed, 9 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
> index e44933d..ca9261a 100644
> --- a/drivers/isdn/capi/capi.c
> +++ b/drivers/isdn/capi/capi.c
> @@ -1015,14 +1015,11 @@ capinc_tty_install(struct tty_driver *driver, struct tty_struct *tty)
>  {
>  	int idx = tty->index;
>  	struct capiminor *mp = capiminor_get(idx);
> -	int ret = tty_init_termios(tty);
> +	int ret = tty_standard_install(tty);

This, and, all of the other calls in this patch, should be (driver, tty)
for the function arguments, right?

That seems to fix the build for me, so I've checked it in, but please
verify that I got it right.

greg k-h
