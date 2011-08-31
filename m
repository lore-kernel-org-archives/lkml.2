Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983Ab1HaUqd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 16:46:33 -0400
Received: from smtp.opengridcomputing.com ([209.198.142.2]:58289 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752840Ab1HaUqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 16:46:31 -0400
Message-ID: <4E5E9D95.2050601@opengridcomputing.com>
Date: Wed, 31 Aug 2011 15:46:13 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.20) Gecko/20110805 Lightning/1.0b2 Thunderbird/3.1.12
MIME-Version: 1.0
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
CC: Steve Wise <swise@chelsio.com>, Roland Dreier <roland@kernel.org>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: Re: [PATCH] RDMA/cxgb4: remove accidentally left mutex_unlock(&dev_mutex)
References: <1314823410-12621-1-git-send-email-khoroshilov@ispras.ru>
In-Reply-To: <1314823410-12621-1-git-send-email-khoroshilov@ispras.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2011 03:43 PM, Alexey Khoroshilov wrote:
> The patch "RDMA/cxgb4: EEH errors can hang the driver" removes
> mutex lock/unlock from c4iw_alloc() except for error path.
> This patch removes the remained mutex_unlock(&dev_mutex).
>
> Found by Linux Driver Verification project (linuxtesting.org).
>
> Signed-off-by: Alexey Khoroshilov<khoroshilov@ispras.ru>
> ---
>   drivers/infiniband/hw/cxgb4/device.c |    1 -
>   1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
> index 40a13cc..35896ff 100644
> --- a/drivers/infiniband/hw/cxgb4/device.c
> +++ b/drivers/infiniband/hw/cxgb4/device.c
> @@ -414,7 +414,6 @@ static struct c4iw_dev *c4iw_alloc(const struct cxgb4_lld_info *infop)
>
>   	ret = c4iw_rdev_open(&devp->rdev);
>   	if (ret) {
> -		mutex_unlock(&dev_mutex);
>   		printk(KERN_ERR MOD "Unable to open CXIO rdev err %d\n", ret);
>   		ib_dealloc_device(&devp->ibdev);
>   		return ERR_PTR(ret);

This is actually included in my previously submitted patch:

https://patchwork.kernel.org/patch/1026942/

Steve.


