Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759269Ab2CTIYg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 04:24:36 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45367 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758592Ab2CTIYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 04:24:32 -0400
Message-ID: <4F683EBC.2080207@linaro.org>
Date: Tue, 20 Mar 2012 08:24:28 +0000
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] drivers/base: Use DEFINE_IDA for soc_ida
References: <1332226855.2434.1.camel@phoenix>
In-Reply-To: <1332226855.2434.1.camel@phoenix>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

I've already sent the fix for this.

Kind regards,
Lee

On 20/03/12 07:00, Axel Lin wrote:
> soc_ida actually is a struct ida.
> This fixes below build warnings:
> 
>   CC      drivers/base/soc.o
> drivers/base/soc.c: In function 'soc_device_register':
> drivers/base/soc.c:126: warning: passing argument 1 of 'ida_pre_get' from incompatible pointer type
> include/linux/idr.h:142: note: expected 'struct ida *' but argument is of type 'struct idr *'
> drivers/base/soc.c:132: warning: passing argument 1 of 'ida_get_new' from incompatible pointer type
> include/linux/idr.h:144: note: expected 'struct ida *' but argument is of type 'struct idr *'
> drivers/base/soc.c:154: warning: passing argument 1 of 'ida_remove' from incompatible pointer type
> include/linux/idr.h:145: note: expected 'struct ida *' but argument is of type 'struct idr *'
> drivers/base/soc.c: In function 'soc_device_unregister':
> drivers/base/soc.c:164: warning: passing argument 1 of 'ida_remove' from incompatible pointer type
> include/linux/idr.h:145: note: expected 'struct ida *' but argument is of type 'struct idr *'
> drivers/base/soc.c: In function 'soc_bus_unregister':
> drivers/base/soc.c:179: warning: passing argument 1 of 'ida_destroy' from incompatible pointer type
> include/linux/idr.h:146: note: expected 'struct ida *' but argument is of type 'struct idr *'
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/base/soc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/base/soc.c b/drivers/base/soc.c
> index 05f1503..e57aec1 100644
> --- a/drivers/base/soc.c
> +++ b/drivers/base/soc.c
> @@ -15,7 +15,7 @@
>  #include <linux/sys_soc.h>
>  #include <linux/err.h>
>  
> -static DEFINE_IDR(soc_ida);
> +static DEFINE_IDA(soc_ida);
>  static DEFINE_SPINLOCK(soc_lock);
>  
>  static ssize_t soc_info_get(struct device *dev,


-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
