Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab0JOOoB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 10:44:01 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:29617 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755298Ab0JOOoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 10:44:00 -0400
Message-ID: <4CB868B2.60407@vmware.com>
Date: Fri, 15 Oct 2010 16:44:02 +0200
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100624 Mandriva/3.0.5-0.1mdv2009.1 (2009.1) Thunderbird/3.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Dave Airlie <airlied@redhat.com>, Jerome Glisse <jglisse@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2.6.36-rc7] drm/ttm: use cancel_delayed_work_sync() in
 ttm_bo
References: <4CB84532.5020809@kernel.org>
In-Reply-To: <4CB84532.5020809@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2010 02:12 PM, Tejun Heo wrote:
> Make ttm_bo::ttm_bo_device_release call cancel_delayed_work_sync()
> instead of calling cancel_delayed_work() followed by
> flush_scheduled_work().
>
> This is to prepare for the deprecation and removal of
> flush_scheduled_work().
>
> Signed-off-by: Tejun Heo<tj@kernel.org>
>    
Acked-by: Thomas Hellstrom <thellstrom@vmware.com>

Thanks,
Thomas


> ---
>   drivers/gpu/drm/ttm/ttm_bo.c |    3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> Index: work/drivers/gpu/drm/ttm/ttm_bo.c
> ===================================================================
> --- work.orig/drivers/gpu/drm/ttm/ttm_bo.c
> +++ work/drivers/gpu/drm/ttm/ttm_bo.c
> @@ -1480,8 +1480,7 @@ int ttm_bo_device_release(struct ttm_bo_
>   	list_del(&bdev->device_list);
>   	mutex_unlock(&glob->device_list_mutex);
>
> -	if (!cancel_delayed_work(&bdev->wq))
> -		flush_scheduled_work();
> +	cancel_delayed_work_sync(&bdev->wq);
>
>   	while (ttm_bo_delayed_delete(bdev, true))
>   		;
>    

