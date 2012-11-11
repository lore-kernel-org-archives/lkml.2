Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291Ab2KKW1q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 17:27:46 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46619 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030Ab2KKW1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 17:27:45 -0500
Message-ID: <50A0265B.8040209@gmail.com>
Date: Mon, 12 Nov 2012 09:27:39 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>
CC: linux-kernel@vger.kernel.org, Shreyas Bhatewara <sbhatewara@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>, netdev@vger.kernel.org
Subject: Re: [PATCH] vmxnet3: convert BUG_ON(true) into a simple BUG()
References: <1352406191-14303-1-git-send-email-sasha.levin@oracle.com>
In-Reply-To: <1352406191-14303-1-git-send-email-sasha.levin@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/12 07:23, Sasha Levin wrote:
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>  drivers/net/vmxnet3/vmxnet3_drv.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
> index 0ae1bcc..7e9622f 100644
> --- a/drivers/net/vmxnet3/vmxnet3_drv.c
> +++ b/drivers/net/vmxnet3/vmxnet3_drv.c
> @@ -1922,7 +1922,7 @@ vmxnet3_free_irqs(struct vmxnet3_adapter *adapter)
>  		free_irq(adapter->pdev->irq, adapter->netdev);
>  		break;
>  	default:
> -		BUG_ON(true);
> +		BUG();
>  	}
>  }

All of the BUG_ON tests in this function look like programming error
assertions. It looks like the worst that would happen is that some irqs
might not be properly released, not the sort of thing that is going to
make the system unstable if you don't bug.

Can't they just be replaced with (for example):

	if (WARN_ON(blah))
		return;

Or even just:

	netdev_err(adapter->netdev, "bad irq type %d for free\n",
			intr->type);

~Ryan

