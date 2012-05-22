Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab2EVIIR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 04:08:17 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:40042 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917Ab2EVIIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 04:08:12 -0400
Date: Tue, 22 May 2012 11:11:50 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        fmhess@users.sourceforge.net, abbotti@mev.co.uk,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH] staging: comedi: ii_pci20kc: iobase and ioaddr are void
 __iomem *
Message-ID: <20120522081150.GE4637@mwanda>
References: <201205211810.07454.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201205211810.07454.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 06:10:07PM -0700, H Hartley Sweeten wrote:
> @@ -210,7 +210,7 @@ static int pci20xxx_attach(struct comedi_device *dev,
>  	if (ret < 0)
>  		return ret;
>  
> -	devpriv->ioaddr = (void *)(unsigned long)it->options[0];
> +	devpriv->ioaddr = (void __iomem *)(unsigned long)it->options[0];


Obviously, your patch is fine, but I was wondering if it was a
problem that it->options was only a 32 bit?  Seems like it would
deserve a comment.

regards,
dan carpenter


