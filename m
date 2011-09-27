Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab1I0OQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 10:16:26 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:24805 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab1I0OQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 10:16:25 -0400
Date: Tue, 27 Sep 2011 17:13:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johannes Thumshirn <morbidrsa@googlemail.com>
Cc: gregkh@suse.de, abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: comedi: Added log subjects to printk()s in
 pcmmio
Message-ID: <20110927141326.GG10999@longonot.mountain>
References: <1316926152-7258-1-git-send-email-morbidrsa@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316926152-7258-1-git-send-email-morbidrsa@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A020202.4E81DAA7.008D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 25, 2011 at 06:49:12AM +0200, Johannes Thumshirn wrote:
> -	printk("comedi%d: %s: io: %lx ", dev->minor, driver.driver_name,
> +	printk(KERN_INFO "comedi%d: %s: io: %lx ", dev->minor, driver.driver_name,
>  	       iobase);
>  
>  	dev->iobase = iobase;
> @@ -379,7 +379,7 @@ static int pcmmio_attach(struct comedi_device *dev, struct comedi_devconfig *it)
>  	if (!iobase || !request_region(iobase,
>  				       thisboard->total_iosize,
>  				       driver.driver_name)) {
> -		printk("I/O port conflict\n");
> +		printk(KERN_ERR "I/O port conflict\n");

The KERN_ERR stuff is only supposed to be used at the start of the
line of output.  (The previous KERN_INFO printk didn't have a new
line at the end).

All this code needs to be rewritten so each printk() only prints
one line.  Otherwise you could get messages printed out in the
middle of other messages and it looks like crap.

This code is trickier than it looks.  Quite a few newbies have run
into trouble here.  My advice is to start with something that looks
tricky so at least if you mess up, you were doing something awesome.
:)

regards,
dan carpenter

