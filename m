Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab2G0FDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 01:03:42 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:54700 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752678Ab2G0FDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 01:03:41 -0400
Message-ID: <1343365419.2040.14.camel@joe2Laptop>
Subject: Re: [PATCH] staging/olpc_dcon: fix checkpatch warnings
From: Joe Perches <joe@perches.com>
To: Toshiaki Yamane <yamanetoshi@gmail.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>, Andres Salomon <dilinger@queued.net>,
        Chris Ball <cjb@laptop.org>, Jon Nettleton <jon.nettleton@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 26 Jul 2012 22:03:39 -0700
In-Reply-To: <1343364390-11410-1-git-send-email-yamanetoshi@gmail.com>
References: <1343346559-8416-1-git-send-email-yamanetoshi@gmail.com>
	 <1343364390-11410-1-git-send-email-yamanetoshi@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-27 at 13:46 +0900, Toshiaki Yamane wrote:
> fixed some checkpatch warnings.
> (Excluding -WARNING: msleep < 20ms can sleep for up to 20ms-)
[]
> diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c b/drivers/staging/olpc_dcon/olpc_dcon.c
[]
> @@ -71,18 +72,18 @@ static int dcon_hw_init(struct dcon_priv *dcon, int is_init)
>  
>  	ver = dcon_read(dcon, DCON_REG_ID);
>  	if ((ver >> 8) != 0xDC) {
> -		printk(KERN_ERR "olpc-dcon:  DCON ID not 0xDCxx: 0x%04x instead.\n",
> -			ver);
> +		pr_err("DCON ID not 0xDCxx: 0x%04x instead.\n",
> +		       ver);

Please fit arguments on a single line where feasible.

		pr_err("DCON ID not 0xDCxx: 0x%04x instead.\n", ver);
[]

> @@ -231,7 +232,7 @@ static void dcon_sleep(struct dcon_priv *dcon, bool sleep)
>  			dcon->disp_mode |= MODE_BL_ENABLE;
>  		x = dcon_bus_stabilize(dcon, 1);
>  		if (x)
> -			printk(KERN_WARNING "olpc-dcon:  unable to reinit dcon hardware: %d!\n",
> +			pr_warn("unable to reinit dcon hardware: %d!\n",
>  				x);

			pr_warn("unable to reinit dcon hardware: %d!\n", x);

etc.

