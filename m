Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353Ab1GRRZr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 13:25:47 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65258 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207Ab1GRRZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 13:25:46 -0400
Date: Mon, 18 Jul 2011 20:23:51 +0300
From: Dan Carpenter <error27@gmail.com>
To: Ravishankar <ravishankarkm32@gmail.com>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>
Subject: Re: [PATCH 1/2] Staging: comedi: fix printk() issue in adv_pci1710.c
Message-ID: <20110718172351.GC4010@shale.localdomain>
References: <1310996009-21674-1-git-send-email-ravishankarkm32@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310996009-21674-1-git-send-email-ravishankarkm32@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 07:03:29PM +0530, Ravishankar wrote:
> --- a/drivers/staging/comedi/drivers/adv_pci1710.c
> +++ b/drivers/staging/comedi/drivers/adv_pci1710.c
> @@ -1396,14 +1396,14 @@ static int pci1710_attach(struct comedi_device *dev,
>  	int i;
>  	int board_index;
>  
> -	printk("comedi%d: adv_pci1710: ", dev->minor);
> +	printk(KERN_INFO "comedi%d: adv_pci1710: ", dev->minor);
>  
>  	opt_bus = it->options[0];
>  	opt_slot = it->options[1];
>  
>  	ret = alloc_private(dev, sizeof(struct pci1710_private));
>  	if (ret < 0) {
> -		printk(" - Allocation failed!\n");
> +		printk(KERN_INFO " - Allocation failed!\n");

This is on the same line as the previous printk() so KERN_INFO isn't
correct.

regards,
dan carpenter

