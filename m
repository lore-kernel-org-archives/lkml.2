Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268Ab1BPEfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 23:35:45 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:65502 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab1BPEfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 23:35:43 -0500
Date: Tue, 15 Feb 2011 21:35:40 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Thomas Chou <thomas@wytron.com.tw>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
        nios2-dev@sopc.et.ntust.edu.tw, devicetree-discuss@lists.ozlabs.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c-ocores: register devices on child nodes
Message-ID: <20110216043540.GB11684@angua.secretlab.ca>
References: <1297306314-11483-1-git-send-email-thomas@wytron.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297306314-11483-1-git-send-email-thomas@wytron.com.tw>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 10:51:54AM +0800, Thomas Chou wrote:
> This patch registers devices on the devicetree child nodes to the bus.
> Also removes one trailing whitespace.
> 
> Signed-off-by: Thomas Chou <thomas@wytron.com.tw>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

Ben, do you want to pick this one up?  Or should I merge it via my
devicetree branch?

g.

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
