Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759030Ab2FEGPs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 02:15:48 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54620 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463Ab2FEGPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 02:15:47 -0400
Date: Mon, 4 Jun 2012 20:22:21 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        H Hartley Sweeten <hartleys@visionengravers.com>
Subject: Re: [PATCH] staging: comedi: ii_pci20kc: iobase and ioaddr are void
 __iomem *
Message-ID: <20120605032221.GA32598@kroah.com>
References: <201205211810.07454.hartleys@visionengravers.com>
 <20120522081150.GE4637@mwanda>
 <4FBB6730.10802@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBB6730.10802@mev.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 11:15:12AM +0100, Ian Abbott wrote:
> On 2012-05-22 09:11, Dan Carpenter wrote:
> >On Mon, May 21, 2012 at 06:10:07PM -0700, H Hartley Sweeten wrote:
> >>@@ -210,7 +210,7 @@ static int pci20xxx_attach(struct comedi_device *dev,
> >>  	if (ret<  0)
> >>  		return ret;
> >>
> >>-	devpriv->ioaddr = (void *)(unsigned long)it->options[0];
> >>+	devpriv->ioaddr = (void __iomem *)(unsigned long)it->options[0];
> >
> >
> >Obviously, your patch is fine, but I was wondering if it was a
> >problem that it->options was only a 32 bit?  Seems like it would
> >deserve a comment.
> 
> Yes, it's a bit of a strange driver, this one.  It's a driver for a
> module sitting on a PCI card, but there is no driver I know of for
> the PCI card, and I've no idea what's actually ioremap'ing the
> memory!
> 
> Maybe we should quietly drop it and see if anyone complains?

I'm all for deleting code :)

Send me a patch removing it and I'll be glad to apply it.

thanks,

greg k-h
