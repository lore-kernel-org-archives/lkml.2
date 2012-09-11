Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045Ab2IKDpF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 23:45:05 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60736 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab2IKDpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 23:45:03 -0400
Date: Mon, 10 Sep 2012 20:44:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: Bruce Humphrey <brucehum@gmail.com>, abbotti@mev.co.uk,
        fmhess@users.sourceforge.net, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: drivers: fl512: change printk(KERN_INFO
 ... for the prefered pr_info(...
Message-ID: <20120911034457.GA3317@kroah.com>
References: <1347331815-7278-1-git-send-email-brucehum@gmail.com>
 <20120911025252.GA28112@kroah.com>
 <1347334811.2073.2.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347334811.2073.2.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 08:40:11PM -0700, Joe Perches wrote:
> On Mon, 2012-09-10 at 19:52 -0700, Greg KH wrote:
> > On Tue, Sep 11, 2012 at 04:50:15AM +0200, Bruce Humphrey wrote:
> > > Change 5 instances of printk(KERN_INFO, KERN_WARN and KERN_ERROR for the prefered pr_info, pr_warn and pr_error
> []
> > > diff --git a/drivers/staging/comedi/drivers/fl512.c b/drivers/staging/comedi/drivers/fl512.c
> []
> > > @@ -118,9 +118,9 @@ static int fl512_attach(struct comedi_device *dev, struct comedi_devconfig *it)
> []
> > > -	printk(KERN_INFO "comedi:%d fl512: 0x%04lx", dev->minor, iobase);
> > > +	pr_info("comedi:%d fl512: 0x%04lx", dev->minor, iobase);
> > 
> > Why can't you use dev_info() here, and in other places?  You should use
> > the dev_* functions instead of pr_* wherever possible.
> 
> Checkpatch instigates these conversions.

I know.

> Perhaps something like:

That looks like a good start, until someone tries to use netdev_* in a
random non-network driver :)

greg k-h
