Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760247Ab2J2RVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 13:21:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51132 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757317Ab2J2RVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 13:21:37 -0400
Message-ID: <508EBB1E.9060400@vflare.org>
Date: Mon, 29 Oct 2012 10:21:34 -0700
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121017 Thunderbird/16.0.1
MIME-Version: 1.0
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] zram: handle mem suffixes in disk size zram_sysfs
 parameter
References: <20121027160347.GB4771@swordfish>
In-Reply-To: <20121027160347.GB4771@swordfish>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2012 09:03 AM, Sergey Senozhatsky wrote:
>    zram: handle mem suffixes in disk size zram_sysfs parameter
>
>    Use memparse() to allow mem suffixes in disksize sysfs number.
>    Examples:
>         echo 256K > /sys/block/zram0/disksize
>         echo 512M > /sys/block/zram0/disksize
>         echo 1G > /sys/block/zram0/disksize
>
>    Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
>
> ---
>
>   drivers/staging/zram/zram_sysfs.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/staging/zram/zram_sysfs.c b/drivers/staging/zram/zram_sysfs.c
> index edb0ed4..6be318e 100644
> --- a/drivers/staging/zram/zram_sysfs.c
> +++ b/drivers/staging/zram/zram_sysfs.c
> @@ -15,6 +15,7 @@
>   #include <linux/device.h>
>   #include <linux/genhd.h>
>   #include <linux/mm.h>
> +#include <linux/kernel.h>
>
>   #include "zram_drv.h"
>
> @@ -54,13 +55,12 @@ static ssize_t disksize_show(struct device *dev,
>   static ssize_t disksize_store(struct device *dev,
>   		struct device_attribute *attr, const char *buf, size_t len)
>   {
> -	int ret;
>   	u64 disksize;
>   	struct zram *zram = dev_to_zram(dev);
>
> -	ret = kstrtoull(buf, 10, &disksize);
> -	if (ret)
> -		return ret;
> +	disksize = memparse(buf, NULL);
> +	if (disksize < 1)
> +		return -EINVAL;
>

or, just: if (!disksize) ...

Thanks,
Nitin


