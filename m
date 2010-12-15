Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab0LOO3J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 09:29:09 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55710 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066Ab0LOO3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 09:29:08 -0500
Date: Wed, 15 Dec 2010 08:29:00 -0600
From: Jon Mason <jon.mason@exar.com>
To: Tejun Heo <tj@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next-2.6] vxge: add missing flush of reset_task
Message-ID: <20101215142859.GA13516@exar.com>
References: <4D08CAB1.6040402@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D08CAB1.6040402@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 06:03:29AM -0800, Tejun Heo wrote:
> Commit 6e07ebd84 (drivers/net: remove unnecessary
> flush_scheduled_work() calls) incorrectly removed the flush call
> without replacing it with the appropriate work specific operation.
> Fix it by flushing vdev->reset_task explicitly.
> 
> Pointed out by Jon Mason.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Jon Mason <jon.mason@exar.com>
Acked-by: Jon Mason <jon.mason@exar.com>
> ---
>  drivers/net/vxge/vxge-main.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/vxge/vxge-main.c b/drivers/net/vxge/vxge-main.c
> index 537ad87..1ac9b56 100644
> --- a/drivers/net/vxge/vxge-main.c
> +++ b/drivers/net/vxge/vxge-main.c
> @@ -3439,6 +3439,8 @@ static void vxge_device_unregister(struct __vxge_hw_device *hldev)
> 
>  	strncpy(buf, dev->name, IFNAMSIZ);
> 
> +	flush_work_sync(&vdev->reset_task);
> +
>  	/* in 2.6 will call stop() if device is up */
>  	unregister_netdev(dev);
> 
