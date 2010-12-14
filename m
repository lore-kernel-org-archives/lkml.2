Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759289Ab0LNRvm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 12:51:42 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:4846 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758072Ab0LNRvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 12:51:40 -0500
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Subject: Re: [PATCH net-next-2.6] bnx2: remove cancel_work_sync() from
 remove_one
From: "Michael Chan" <mchan@broadcom.com>
To: "Tejun Heo" <tj@kernel.org>
cc: lkml <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
In-Reply-To: <4D0796D7.3030309@kernel.org>
References: <4D0796D7.3030309@kernel.org>
Date: Tue, 14 Dec 2010 09:48:00 -0800
Message-ID: <1292348880.7394.63.camel@nseg_linux_HP1.broadcom.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5)
X-WSS-ID: 6119714C0IO2607887-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2010-12-14 at 08:09 -0800, Tejun Heo wrote:
> Michael pointed out that bnx2_close() already cancels bp->reset_task
> and thus it is guaranteed to be idle when bnx2_remove_one() is called.
> Remove the unnecessary cancel_work_sync() in remove_one.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Michael Chan <mchan@broadcom.com>

Acked-by: Michael Chan <mchan@broadcom.com>

> ---
>  drivers/net/bnx2.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/net/bnx2.c b/drivers/net/bnx2.c
> index 5c811f3..85fc2c8 100644
> --- a/drivers/net/bnx2.c
> +++ b/drivers/net/bnx2.c
> @@ -8393,8 +8393,6 @@ bnx2_remove_one(struct pci_dev *pdev)
>  	struct net_device *dev = pci_get_drvdata(pdev);
>  	struct bnx2 *bp = netdev_priv(dev);
> 
> -	cancel_work_sync(&bp->reset_task);
> -
>  	unregister_netdev(dev);
> 
>  	if (bp->mips_firmware)
> 


