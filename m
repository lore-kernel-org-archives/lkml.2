Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757820Ab2EaHiv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 03:38:51 -0400
Received: from mail-gh0-f180.google.com ([209.85.160.180]:54945 "EHLO
	mail-gh0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278Ab2EaHiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 03:38:50 -0400
Date: Thu, 31 May 2012 14:08:40 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Asai Thambi S P <asamymuthupa@micron.com>
Cc: Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: Re: [PATCH 10/11] mtip32xx: Changes to sysfs entries
Message-ID: <20120531060840.GA14755@kroah.com>
References: <4FC57B96.30500@micron.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FC57B96.30500@micron.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 06:44:54PM -0700, Asai Thambi S P wrote:
> 
> * Formatted the output of 'registers' entry
> * Added "Commands in Q' to output of 'registers' entry
> * Added a new entry 'flags'
> 
> Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
> ---
>  Documentation/ABI/testing/sysfs-block-rssd |   12 ++++-
>  drivers/block/mtip32xx/mtip32xx.c          |   76 +++++++++++++++++++++-------
>  2 files changed, 67 insertions(+), 21 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-block-rssd b/Documentation/ABI/testing/sysfs-block-rssd
> index d535757..679ce35 100644
> --- a/Documentation/ABI/testing/sysfs-block-rssd
> +++ b/Documentation/ABI/testing/sysfs-block-rssd
> @@ -6,13 +6,21 @@ Description:    This is a read-only file. Dumps below driver information and
>                  hardware registers.
>                      - S ACTive
>                      - Command Issue
> -                    - Allocated
>                      - Completed
>                      - PORT IRQ STAT
>                      - HOST IRQ STAT
> +                    - Allocated
> +                    - Commands in Q
>  
>  What:           /sys/block/rssd*/status
>  Date:           April 2012
>  KernelVersion:  3.4
>  Contact:        Asai Thambi S P <asamymuthupa@micron.com>
> -Description:   This is a read-only file. Indicates the status of the device.
> +Description:    This is a read-only file. Indicates the status of the device.
> +
> +What:           /sys/block/rssd*/flags
> +Date:           May 2012
> +KernelVersion:  3.5
> +Contact:        Asai Thambi S P <asamymuthupa@micron.com>
> +Description:    This is a read-only file. Dumps the flags in port and driver
> +                data structure
> diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
> index d0fa357..18daa04 100644
> --- a/drivers/block/mtip32xx/mtip32xx.c
> +++ b/drivers/block/mtip32xx/mtip32xx.c
> @@ -2562,40 +2562,58 @@ static ssize_t mtip_hw_show_registers(struct device *dev,
>  	int size = 0;
>  	int n;
>  
> -	size += sprintf(&buf[size], "S ACTive:\n");
> +	size += sprintf(&buf[size], "Hardware\n--------\n");
> +	size += sprintf(&buf[size], "S ACTive      : [ 0x");
>  
> -	for (n = 0; n < dd->slot_groups; n++)
> -		size += sprintf(&buf[size], "0x%08x\n",
> +	for (n = dd->slot_groups-1; n >= 0; n--)
> +		size += sprintf(&buf[size], "%08X ",
>  					 readl(dd->port->s_active[n]));

<snip>

WHAT???

No, this needs to be a debugfs file, sysfs is "one value per file",
stuff like this is not allowed at all.

Please remove these sysfs files entirely, they are not allowed.  If you
feel you really need them, put them in debugfs.

As-is, this patch is not acceptable, and a follow-on patch needs to be
created to remove these sysfs files now.

thanks,

greg k-h
