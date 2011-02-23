Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab1BWANH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 19:13:07 -0500
Received: from trinity.fluff.org ([89.16.178.74]:49725 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754925Ab1BWANF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 19:13:05 -0500
Date: Wed, 23 Feb 2011 00:12:52 +0000
From: Ben Dooks <ben-i2c@fluff.org>
To: Thomas Chou <thomas@wytron.com.tw>
Cc: Grant Likely <grant.likely@secretlab.ca>, Ben Dooks <ben-linux@fluff.org>,
        linux-kernel@vger.kernel.org, nios2-dev@sopc.et.ntust.edu.tw,
        devicetree-discuss@lists.ozlabs.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c-ocores: register devices on child nodes
Message-ID: <20110223001252.GT15795@trinity.fluff.org>
References: <1297306314-11483-1-git-send-email-thomas@wytron.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297306314-11483-1-git-send-email-thomas@wytron.com.tw>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 10:51:54AM +0800, Thomas Chou wrote:
> This patch registers devices on the devicetree child nodes to the bus.
> Also removes one trailing whitespace.

Is this required as an urgent fix, or can it queue for next merge window?
 
> Signed-off-by: Thomas Chou <thomas@wytron.com.tw>
> ---
>  drivers/i2c/busses/i2c-ocores.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-ocores.c b/drivers/i2c/busses/i2c-ocores.c
> index ef3bcb1..c63838f 100644
> --- a/drivers/i2c/busses/i2c-ocores.c
> +++ b/drivers/i2c/busses/i2c-ocores.c
> @@ -18,7 +18,7 @@
>   * - interrupts      : interrupt number
>   * - regstep         : size of device registers in bytes
>   * - clock-frequency : frequency of bus clock in Hz
> - * 
> + *
>   * Example:
>   *
>   *  i2c0: ocores@a0000000 {
> @@ -55,6 +55,7 @@
>  #include <linux/i2c-ocores.h>
>  #include <linux/slab.h>
>  #include <linux/io.h>
> +#include <linux/of_i2c.h>
>  
>  struct ocores_i2c {
>  	void __iomem *base;
> @@ -347,6 +348,9 @@ static int __devinit ocores_i2c_probe(struct platform_device *pdev)
>  			i2c_new_device(&i2c->adap, pdata->devices + i);
>  	}
>  
> +	/* Now register all the child nodes */
> +	of_i2c_register_devices(&i2c->adap);
> +
>  	return 0;
>  }
>  
> -- 
> 1.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-i2c" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Ben Dooks, ben@fluff.org, http://www.fluff.org/ben/

Large Hadron Colada: A large Pina Colada that makes the universe disappear.

