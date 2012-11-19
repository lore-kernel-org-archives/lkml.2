Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab2KSPUb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 10:20:31 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:37746 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753063Ab2KSPU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 10:20:29 -0500
Message-ID: <1353338430.5287.6.camel@joe-AO722>
Subject: Re: [PATCH v2 1/2] Staging: comedi: drivers: replaced printk with
 dev_dbg
From: Joe Perches <joe@perches.com>
To: Arpith Easow Alexander <arpith99@gmail.com>
Cc: abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        gregkh@linuxfoundation.org, hsweeten@visionengravers.com,
        dan.carpenter@oracle.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Mon, 19 Nov 2012 07:20:30 -0800
In-Reply-To: <20121119151419.GA4807@gmail.com>
References: <20121119151419.GA4807@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-19 at 20:44 +0530, Arpith Easow Alexander wrote:
> This is a patch to the vmk80xx.c file that replaces the printk with dev_dbg.
> This fixes the warnings found by the checkpatch.pl tool.

The commit message is missing description of why
some printk(KERN_INFO are converted to dev_dbg

Also, it'd be better to remove the dbgcm macro
altogether and just use dev_dbg.

> diff --git a/drivers/staging/comedi/drivers/vmk80xx.c b/drivers/staging/comedi/drivers/vmk80xx.c
[]
> @@ -131,10 +131,10 @@ static int dbgcm = 1;
>  static int dbgcm;
>  #endif
>  
> -#define dbgcm(fmt, arg...)                     \
> +#define dbgcm(dev, fmt, arg...)                     \
>  do {                                           \
>  	if (dbgcm)                             \
> -		printk(KERN_DEBUG fmt, ##arg); \
> +		dev_dbg(dev, fmt, ##arg); \
>  } while (0)

The dbgcm variable and macro isn't really necessary
because dynamic_debug has all the same capability.

> @@ -1371,14 +1373,16 @@ static int vmk80xx_usb_probe(struct usb_interface *intf,
>  
>  	if (dev->board.model == VMK8061_MODEL) {
>  		vmk80xx_read_eeprom(dev, IC3_VERSION);
> -		printk(KERN_INFO "comedi#: vmk80xx: %s\n", dev->fw.ic3_vers);
> +		dev_dbg(&(dev->udev->dev),
> +			"comedi#: vmk80xx: %s\n", dev->fw.ic3_vers);

This likely should not be dev_dbg.


