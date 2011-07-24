Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708Ab1GXMvZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 08:51:25 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54589 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab1GXMvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 08:51:22 -0400
Date: Sun, 24 Jul 2011 15:49:22 +0300
From: Dan Carpenter <error27@gmail.com>
To: Ravishankar <ravishankarkm32@gmail.com>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>
Subject: Re: [PATCH 1/1 v3] Staging: comedi: fix printk issue in das6402.c
Message-ID: <20110724124922.GB3711@shale.localdomain>
References: <1311319655-4324-1-git-send-email-ravishankarkm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311319655-4324-1-git-send-email-ravishankarkm@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 12:57:35PM +0530, Ravishankar wrote:
> @@ -322,10 +321,11 @@ static int das6402_attach(struct comedi_device *dev,
>  	if (iobase == 0)
>  		iobase = 0x300;
>  
> -	printk(KERN_INFO "comedi%d: das6402: 0x%04lx", dev->minor, iobase);
> +	pr_info("comedi%d: das6402: 0x%04lx", dev->minor, iobase);
>  
>  	if (!request_region(iobase, DAS6402_SIZE, "das6402")) {
> -		printk(KERN_CONT " I/O port conflict\n");
> +		pr_cont("I/O port conflict\n");
> +		dev_dbg(dev->hw_dev, "I/O port conflict\n");

Why are we printing this out twice here?

Really, I think maybe you shouldn't be sending cleanup patches.  It
looks easy but it's actually tricky.  Kernel programming is not a
very good or very fun place for learners.  Sorry for this.  :/

>  		return -EIO;
>  	}
>  	dev->iobase = iobase;

regards,
dan carpenter
