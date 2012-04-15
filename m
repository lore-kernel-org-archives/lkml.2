Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab2DOWJy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 18:09:54 -0400
Received: from lunge.queued.net ([173.255.254.236]:40284 "EHLO
	lunge.queued.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab2DOWJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 18:09:53 -0400
Date: Sun, 15 Apr 2012 15:07:53 -0700
From: Andres Salomon <dilinger@queued.net>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Jordan Crouse <jordan@cosmicpenguin.net>, Chris Ball <cjb@laptop.org>,
        Jon Nettleton <jon.nettleton@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Valentin Rothberg <valentinrothberg@googlemail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging: olpc_dcon.c: checkpatch.pl and style fixups
Message-ID: <20120415150753.2f96cab7@debxo>
In-Reply-To: <alpine.LNX.2.00.1204152338270.18522@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1204150049270.15578@swampdragon.chaosbits.net>
	<20120414192638.31fa501d@debxo>
	<alpine.LNX.2.00.1204152338270.18522@swampdragon.chaosbits.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Apr 2012 23:39:32 +0200 (CEST)
Jesper Juhl <jj@chaosbits.net> wrote:
[...]
> Not at all :-)
> 
> How's this?

Looks great, thanks!

Acked-by: Andres Salomon <dilinger@queued.net>


> 
> 
> From: Jesper Juhl <jj@chaosbits.net>
> Date: Sun, 15 Apr 2012 00:38:03 +0200
> Subject: [PATCH] staging: olpc_dcon.c: checkpatch.pl and style fixups
> 
> This patch removes a few checkpatch.pl issues that are currently
> reported for this file.
> 
> It makes these changes:
> 
> 1. Quoted strings that were broken over multiple lines are put on a
>    single line for easier grep'ability.
> 
> 2. Add missing level to a printk().
> 
> 3. A few casts have had their space between the cast and variable
>    removed.
> 
> I have not tested this patch beyond checking that it compiles.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  drivers/staging/olpc_dcon/olpc_dcon.c |   29
> ++++++++++++++--------------- 1 file changed, 14 insertions(+), 15
> deletions(-)
> 
> diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c
> b/drivers/staging/olpc_dcon/olpc_dcon.c index 3d91993..43758c3 100644
> --- a/drivers/staging/olpc_dcon/olpc_dcon.c
> +++ b/drivers/staging/olpc_dcon/olpc_dcon.c
> @@ -71,8 +71,8 @@ static int dcon_hw_init(struct dcon_priv *dcon, int
> is_init) 
>  	ver = dcon_read(dcon, DCON_REG_ID);
>  	if ((ver >> 8) != 0xDC) {
> -		printk(KERN_ERR "olpc-dcon:  DCON ID not 0xDCxx:
> 0x%04x "
> -				"instead.\n", ver);
> +		printk(KERN_ERR "olpc-dcon:  DCON ID not 0xDCxx:
> 0x%04x instead.\n",
> +				ver);
>  		rc = -ENXIO;
>  		goto err;
>  	}
> @@ -134,10 +134,10 @@ static int dcon_bus_stabilize(struct dcon_priv
> *dcon, int is_powered_down) power_up:
>  	if (is_powered_down) {
>  		x = 1;
> -		x = olpc_ec_cmd(0x26, (unsigned char *) &x, 1, NULL,
> 0);
> +		x = olpc_ec_cmd(0x26, (unsigned char *)&x, 1, NULL,
> 0); if (x) {
> -			printk(KERN_WARNING "olpc-dcon:  unable to
> force dcon "
> -					"to power up: %d!\n", x);
> +			printk(KERN_WARNING "olpc-dcon:  unable to
> force dcon to power up: %d!\n",
> +					x);
>  			return x;
>  		}
>  		msleep(10); /* we'll be conservative */
> @@ -150,11 +150,10 @@ power_up:
>  		x = dcon_read(dcon, DCON_REG_ID);
>  	}
>  	if (x < 0) {
> -		printk(KERN_ERR "olpc-dcon:  unable to stabilize
> dcon's "
> -				"smbus, reasserting power and
> praying.\n");
> +		printk(KERN_ERR "olpc-dcon:  unable to stabilize
> dcon's smbus, reasserting power and praying.\n");
> BUG_ON(olpc_board_at_least(olpc_board(0xc2))); x = 0;
> -		olpc_ec_cmd(0x26, (unsigned char *) &x, 1, NULL, 0);
> +		olpc_ec_cmd(0x26, (unsigned char *)&x, 1, NULL, 0);
>  		msleep(100);
>  		is_powered_down = 1;
>  		goto power_up;	/* argh, stupid hardware.. */
> @@ -220,10 +219,10 @@ static void dcon_sleep(struct dcon_priv *dcon,
> bool sleep) 
>  	if (sleep) {
>  		x = 0;
> -		x = olpc_ec_cmd(0x26, (unsigned char *) &x, 1, NULL,
> 0);
> +		x = olpc_ec_cmd(0x26, (unsigned char *)&x, 1, NULL,
> 0); if (x)
> -			printk(KERN_WARNING "olpc-dcon:  unable to
> force dcon "
> -					"to power down: %d!\n", x);
> +			printk(KERN_WARNING "olpc-dcon:  unable to
> force dcon to power down: %d!\n",
> +					x);
>  		else
>  			dcon->asleep = sleep;
>  	} else {
> @@ -232,8 +231,8 @@ static void dcon_sleep(struct dcon_priv *dcon,
> bool sleep) dcon->disp_mode |= MODE_BL_ENABLE;
>  		x = dcon_bus_stabilize(dcon, 1);
>  		if (x)
> -			printk(KERN_WARNING "olpc-dcon:  unable to
> reinit dcon"
> -					" hardware: %d!\n", x);
> +			printk(KERN_WARNING "olpc-dcon:  unable to
> reinit dcon hardware: %d!\n",
> +				x);
>  		else
>  			dcon->asleep = sleep;
>  
> @@ -304,7 +303,7 @@ static void dcon_source_switch(struct work_struct
> *work) 
>  	switch (source) {
>  	case DCON_SOURCE_CPU:
> -		printk("dcon_source_switch to CPU\n");
> +		printk(KERN_INFO "dcon_source_switch to CPU\n");
>  		/* Enable the scanline interrupt bit */
>  		if (dcon_write(dcon, DCON_REG_MODE,
>  				dcon->disp_mode | MODE_SCAN_INT))
> @@ -599,7 +598,7 @@ static int dcon_fb_notifier(struct notifier_block
> *self, struct fb_event *evdata = data;
>  	struct dcon_priv *dcon = container_of(self, struct dcon_priv,
>  			fbevent_nb);
> -	int *blank = (int *) evdata->data;
> +	int *blank = (int *)evdata->data;
>  	if (((event != FB_EVENT_BLANK) && (event !=
> FB_EVENT_CONBLANK)) || dcon->ignore_fb_events)
>  		return 0;

