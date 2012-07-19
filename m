Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751756Ab2GSMuu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 08:50:50 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:33282 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab2GSMus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 08:50:48 -0400
Date: Thu, 19 Jul 2012 15:50:38 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Devendra Naga <devendra.aaru@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/sbe-2t3e3: error path cleanup in
 t3e3_init_channel
Message-ID: <20120719125038.GC16291@mwanda>
References: <1342701001-5424-1-git-send-email-devendra.aaru@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342701001-5424-1-git-send-email-devendra.aaru@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup means there are no behavior changes.  This is a bug fix.

On Thu, Jul 19, 2012 at 06:00:01PM +0530, Devendra Naga wrote:
>     a) if alloc_hdlcdev fails, we are going into the free_regions,
> and returning out the err (which is 0 by the prev call),
>        return -ENOMEM if this function fail.
> 
>     b) setup_device also can fail, as it calls around the register_hdlc_dev which
> is again a macro of the register_netdev.
> 
>        take the error from the setup_device and return it out in error condition
> 
>     c) request_irq when fails, we are freeing requested mem regions and disabling
> the pci device(?) and returning err which is agian 0 here.
> 
>       take the error from request_irq and err path will take care of returning it.
> 
> as if we return 0 , at the init function, t3e3_init_card, we have a success case
> and if there are two channels we call this function again, having the result of
> it completely unknown.
> 
> This result in having the probe return 0, unloading the driver may (not) cause
> ambigous result.

These bugs were there before your patch, but we should also be doing
an unregister_hdlc_device() and a free_netdev().

regards,
dan carpenter

