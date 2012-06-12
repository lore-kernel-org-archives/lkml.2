Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab2FLTuS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 15:50:18 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:48309 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955Ab2FLTuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 15:50:16 -0400
Date: Tue, 12 Jun 2012 22:49:40 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        fmhess@users.sourceforge.net, abbotti@mev.co.uk,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 8/8] staging: comedi: cleanup comedi_alloc_subdevices
Message-ID: <20120612194940.GZ4400@mwanda>
References: <201206121159.55522.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201206121159.55522.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 11:59:55AM -0700, H Hartley Sweeten wrote:
>  	for (i = 0; i < num_subdevices; ++i) {
> -		dev->subdevices[i].device = dev;
> -		dev->subdevices[i].async_dma_dir = DMA_NONE;
> -		spin_lock_init(&dev->subdevices[i].spin_lock);
> -		dev->subdevices[i].minor = -1;
> +		s = dev->subdevices + i;

You don't have to resend, but I think this would look better as:

		s = &dev->subdevices[i];

> +		s->device = dev;
> +		s->async_dma_dir = DMA_NONE;
> +		spin_lock_init(&s->spin_lock);
> +		s->minor = -1;
>  	}

Btw, this patchset is great.  Nice.

regards,
dan carpenter
