Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab1GNHn1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 03:43:27 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58372 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715Ab1GNHnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 03:43:25 -0400
Date: Thu, 14 Jul 2011 10:41:44 +0300
From: Dan Carpenter <error27@gmail.com>
To: Ravishankar <ravishankarkm32@gmail.com>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>
Subject: Re: [PATCH 30/30] Staging: comedi: fix printk() issue in das16m1.c
Message-ID: <20110714074144.GR18655@shale.localdomain>
References: <1310618547-8801-1-git-send-email-ravishankarkm32@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310618547-8801-1-git-send-email-ravishankarkm32@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 10:12:27AM +0530, Ravishankar wrote:
> @@ -690,7 +690,7 @@ static int das16m1_attach(struct comedi_device *dev,
>  	if (!request_region(iobase + DAS16M1_82C55, DAS16M1_SIZE2,
>  			    driver_das16m1.driver_name)) {
>  		release_region(iobase, DAS16M1_SIZE);
> -		printk(" I/O port conflict\n");
> +		printk(KERN_ERR " I/O port conflict\n");

This is a continuation of the last printk line.

>  		return -EIO;
>  	}
>  	dev->iobase = iobase;
> @@ -710,7 +710,7 @@ static int das16m1_attach(struct comedi_device *dev,
>  	} else if (irq == 0) {
>  		printk(", no irq\n");
>  	} else {
> -		printk(", invalid irq\n"
> +		printk(KERN_ERR ", invalid irq\n"

Same.

If you want you can just rewrite the printks completely.  You're not
just limited to adding the KERN_ prefixes, you could make larger
changes than that.

regards,
dan carpenter
