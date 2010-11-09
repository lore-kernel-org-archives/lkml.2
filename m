Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322Ab0KIJkA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 04:40:00 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:9869 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab0KIJj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 04:39:57 -0500
Date: Tue, 9 Nov 2010 10:39:48 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Joe Perches <joe@perches.com>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 32/32] drivers/hwmon/w83781d.c: Use pr_fmt and
 pr_<level>
Message-ID: <20101109103948.25919efe@endymion.delvare>
In-Reply-To: <1ce82b2a1c726d252483c508053eff046abcf132.1287556801.git.joe@perches.com>
References: <20101020035346.GA20178@ericsson.com>
	<1ce82b2a1c726d252483c508053eff046abcf132.1287556801.git.joe@perches.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Tue, 19 Oct 2010 23:51:56 -0700, Joe Perches wrote:
> Added #define pr_fmt KBUILD_MODNAME ": " fmt
> Converted printks to pr_<level>
> Coalesced any long formats
> Removed prefixes from formats
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/hwmon/w83781d.c |   29 ++++++++++++++---------------
>  1 files changed, 14 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/hwmon/w83781d.c b/drivers/hwmon/w83781d.c
> index c84b9b4..d452a20 100644
> --- a/drivers/hwmon/w83781d.c
> +++ b/drivers/hwmon/w83781d.c
> @@ -33,6 +33,8 @@
>  
>  */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/slab.h>
> @@ -1798,8 +1800,7 @@ w83781d_isa_found(unsigned short address)
>  	 * individually for the probing phase. */
>  	for (port = address; port < address + W83781D_EXTENT; port++) {
>  		if (!request_region(port, 1, "w83781d")) {
> -			pr_debug("w83781d: Failed to request port 0x%x\n",
> -				 port);
> +			pr_debug("Failed to request port 0x%x\n", port);
>  			goto release;
>  		}
>  	}
> @@ -1811,7 +1812,7 @@ w83781d_isa_found(unsigned short address)
>  	if (inb_p(address + 2) != val
>  	 || inb_p(address + 3) != val
>  	 || inb_p(address + 7) != val) {
> -		pr_debug("w83781d: Detection failed at step 1\n");
> +		pr_debug("Detection failed at step 1\n");

I think this would be the right time to change this to:

		pr_debug("Detection failed at step %d\n", 1);

and do the same for all 6 messages below, so that the compiler can
store the string only once in the binary.

>  		goto release;
>  	}
>  #undef REALLY_SLOW_IO
> @@ -1820,14 +1821,14 @@ w83781d_isa_found(unsigned short address)
>  	   MSB (busy flag) should be clear initially, set after the write. */
>  	save = inb_p(address + W83781D_ADDR_REG_OFFSET);
>  	if (save & 0x80) {
> -		pr_debug("w83781d: Detection failed at step 2\n");
> +		pr_debug("Detection failed at step 2\n");
>  		goto release;
>  	}
>  	val = ~save & 0x7f;
>  	outb_p(val, address + W83781D_ADDR_REG_OFFSET);
>  	if (inb_p(address + W83781D_ADDR_REG_OFFSET) != (val | 0x80)) {
>  		outb_p(save, address + W83781D_ADDR_REG_OFFSET);
> -		pr_debug("w83781d: Detection failed at step 3\n");
> +		pr_debug("Detection failed at step 3\n");
>  		goto release;
>  	}
>  
> @@ -1835,7 +1836,7 @@ w83781d_isa_found(unsigned short address)
>  	outb_p(W83781D_REG_CONFIG, address + W83781D_ADDR_REG_OFFSET);
>  	val = inb_p(address + W83781D_DATA_REG_OFFSET);
>  	if (val & 0x80) {
> -		pr_debug("w83781d: Detection failed at step 4\n");
> +		pr_debug("Detection failed at step 4\n");
>  		goto release;
>  	}
>  	outb_p(W83781D_REG_BANK, address + W83781D_ADDR_REG_OFFSET);
> @@ -1844,19 +1845,19 @@ w83781d_isa_found(unsigned short address)
>  	val = inb_p(address + W83781D_DATA_REG_OFFSET);
>  	if ((!(save & 0x80) && (val != 0xa3))
>  	 || ((save & 0x80) && (val != 0x5c))) {
> -		pr_debug("w83781d: Detection failed at step 5\n");
> +		pr_debug("Detection failed at step 5\n");
>  		goto release;
>  	}
>  	outb_p(W83781D_REG_I2C_ADDR, address + W83781D_ADDR_REG_OFFSET);
>  	val = inb_p(address + W83781D_DATA_REG_OFFSET);
>  	if (val < 0x03 || val > 0x77) {	/* Not a valid I2C address */
> -		pr_debug("w83781d: Detection failed at step 6\n");
> +		pr_debug("Detection failed at step 6\n");
>  		goto release;
>  	}
>  
>  	/* The busy flag should be clear again */
>  	if (inb_p(address + W83781D_ADDR_REG_OFFSET) & 0x80) {
> -		pr_debug("w83781d: Detection failed at step 7\n");
> +		pr_debug("Detection failed at step 7\n");
>  		goto release;
>  	}
>  
> @@ -1871,7 +1872,7 @@ w83781d_isa_found(unsigned short address)
>  		found = 1;
>  
>  	if (found)
> -		pr_info("w83781d: Found a %s chip at %#x\n",
> +		pr_info("Found a %s chip at %#x\n",
>  			val == 0x30 ? "W83782D" : "W83781D", (int)address);
>  
>   release:
> @@ -1894,21 +1895,19 @@ w83781d_isa_device_add(unsigned short address)
>  	pdev = platform_device_alloc("w83781d", address);
>  	if (!pdev) {
>  		err = -ENOMEM;
> -		printk(KERN_ERR "w83781d: Device allocation failed\n");
> +		pr_err("Device allocation failed\n");
>  		goto exit;
>  	}
>  
>  	err = platform_device_add_resources(pdev, &res, 1);
>  	if (err) {
> -		printk(KERN_ERR "w83781d: Device resource addition failed "
> -		       "(%d)\n", err);
> +		pr_err("Device resource addition failed (%d)\n", err);
>  		goto exit_device_put;
>  	}
>  
>  	err = platform_device_add(pdev);
>  	if (err) {
> -		printk(KERN_ERR "w83781d: Device addition failed (%d)\n",
> -		       err);
> +		pr_err("Device addition failed (%d)\n", err);
>  		goto exit_device_put;
>  	}
>  


-- 
Jean Delvare
