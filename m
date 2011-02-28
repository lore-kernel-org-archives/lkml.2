Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab1B1PQp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 10:16:45 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56391 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330Ab1B1PQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 10:16:44 -0500
Date: Mon, 28 Feb 2011 16:16:41 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, kernel@pengutronix.de,
        Arjan van de Ven <arjan@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 6/6] tty/vt: add some KERN_CONT markers to continuation
 lines
Message-ID: <20110228151641.GN22310@pengutronix.de>
References: <20101124085645.GW4693@pengutronix.de>
 <1290589070-854-6-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1290589070-854-6-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg,

should this patch go via your tree?

Thanks
Uwe

On Wed, Nov 24, 2010 at 09:57:50AM +0100, Uwe Kleine-König wrote:
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  drivers/tty/vt/vt.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
> index a8ec48e..e4b05ad 100644
> --- a/drivers/tty/vt/vt.c
> +++ b/drivers/tty/vt/vt.c
> @@ -2930,11 +2930,11 @@ static int __init con_init(void)
>  	gotoxy(vc, vc->vc_x, vc->vc_y);
>  	csi_J(vc, 0);
>  	update_screen(vc);
> -	printk("Console: %s %s %dx%d",
> +	printk(KERN_DEFAULT "Console: %s %s %dx%d",
>  		vc->vc_can_do_color ? "colour" : "mono",
>  		display_desc, vc->vc_cols, vc->vc_rows);
>  	printable = 1;
> -	printk("\n");
> +	printk(KERN_CONT "\n");
>  
>  	release_console_sem();
>  
> @@ -3084,11 +3084,11 @@ static int bind_con_driver(const struct consw *csw, int first, int last,
>  
>  	printk("Console: switching ");
>  	if (!deflt)
> -		printk("consoles %d-%d ", first+1, last+1);
> +		printk(KERN_CONT "consoles %d-%d ", first+1, last+1);
>  	if (j >= 0) {
>  		struct vc_data *vc = vc_cons[j].d;
>  
> -		printk("to %s %s %dx%d\n",
> +		printk(KERN_CONT "to %s %s %dx%d\n",
>  		       vc->vc_can_do_color ? "colour" : "mono",
>  		       desc, vc->vc_cols, vc->vc_rows);
>  
> @@ -3097,7 +3097,7 @@ static int bind_con_driver(const struct consw *csw, int first, int last,
>  			update_screen(vc);
>  		}
>  	} else
> -		printk("to %s\n", desc);
> +		printk(KERN_CONT "to %s\n", desc);
>  
>  	retval = 0;
>  err:
> -- 
> 1.7.2.3
> 
> 

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
