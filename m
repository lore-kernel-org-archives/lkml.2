Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab1HCXuv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:50:51 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:60741 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755912Ab1HCXuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:50:46 -0400
X-Sasl-enc: Rrqw3sJOLv7FKWvnVM6ALS7W199qyvpV73SpkSCoDss2 1312415445
Date: Wed, 3 Aug 2011 16:50:36 -0700
From: Greg KH <greg@kroah.com>
To: Paul Clements <paul.clements@us.sios.com>
Cc: andrew morton <akpm@linux-foundation.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        nbd-general@lists.sourceforge.net
Subject: Re: [PATCH] nbd: new nbd sysfs entries
Message-ID: <20110803235036.GA18947@kroah.com>
References: <CAECXXi5Q=NwrD3AsnUp41cX1PpM8Qf468-f_ENi8LDpfgyrotA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAECXXi5Q=NwrD3AsnUp41cX1PpM8Qf468-f_ENi8LDpfgyrotA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 03, 2011 at 07:32:39PM -0400, Paul Clements wrote:
> Description: Add 3 new sysfs entries to nbd.
> 
> # cat /sys/block/nbd6/nbd/peer
> 127.0.0.1
> # cat /sys/block/nbd6/nbd/flags
> 0
> # cat /sys/block/nbd6/nbd/xmit_timeout
> 6

Any new sysfs file (or removal or modification) also requires a matching
Documentation/ABI/ file as well.  Please include it in this patch (if it
ends up surviving...)

> This patch depends on patch nbd-sysfs-framework.diff

I didn't like that one, it was wrong and I also think you caused a
reference count issue by adding a kobject to that structure...



> Description: Add 3 new sysfs entries to nbd.
> 
> # cat /sys/block/nbd6/nbd/peer 
> 127.0.0.1
> # cat /sys/block/nbd6/nbd/flags 
> 0
> # cat /sys/block/nbd6/nbd/xmit_timeout 
> 6
> 
> This patch depends on patch nbd-sysfs-framework.diff
> 
> From: Paul Clements <paul.clements@steeleye.com>
> Signed-off-by: Paul Clements <paul.clements@steeleye.com>
> ---
> 
>  nbd.c |   79 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 77 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
> index 23f3619..44cd41d 100644
> --- a/drivers/block/nbd.c
> +++ b/drivers/block/nbd.c
> @@ -136,7 +136,7 @@ static void sock_shutdown(struct nbd_device *lo, int lock)
>  		mutex_unlock(&lo->tx_lock);
>  }
>  
> -static void nbd_xmit_timeout(unsigned long arg)
> +static void xmit_timeout(unsigned long arg)

Why change the name of this function?  You now have a function, field,
and sysfs file with that same name, talk about a way to cause confusion
when reading the code :(

greg k-h
