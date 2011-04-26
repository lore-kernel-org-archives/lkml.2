Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab1DZKqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 06:46:21 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59601 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab1DZKqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 06:46:20 -0400
Message-ID: <4DB6A216.1010609@mvista.com>
Date: Tue, 26 Apr 2011 14:44:38 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@redhat.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 029/173] pata_mpc52xx: inherit from ata_bmdma_port_ops
References: <20110425200234.252228845@pcw.home.local>
In-Reply-To: <20110425200234.252228845@pcw.home.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 26-04-2011 0:03, Willy Tarreau wrote:

> 2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

    DMA support was added to this driver only in 2.6.29, hence this patch is 
not needed in 2.6.27.y...

> ------------------

> From: Tejun Heo<tj@kernel.org>

> commit 77c5fd19075d299fe820bb59bb21b0b113676e20 upstream.

> pata_mpc52xx supports BMDMA but inherits ata_sff_port_ops which
> triggers BUG_ON() when a DMA command is issued.  Fix it.

> Signed-off-by: Tejun Heo<tj@kernel.org>
> Reported-by: Roman Fietze<roman.fietze@telemotive.de>
> Cc: Sergei Shtylyov<sshtylyov@mvista.com>
> Signed-off-by: Jeff Garzik<jgarzik@redhat.com>
> Signed-off-by: Greg Kroah-Hartman<gregkh@suse.de>

> ---
>   drivers/ata/pata_mpc52xx.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

> --- a/drivers/ata/pata_mpc52xx.c
> +++ b/drivers/ata/pata_mpc52xx.c
> @@ -610,7 +610,7 @@ static struct scsi_host_template mpc52xx
>   };
>
>   static struct ata_port_operations mpc52xx_ata_port_ops = {
> -	.inherits		=&ata_sff_port_ops,
> +	.inherits		=&ata_bmdma_port_ops,
>   	.sff_dev_select		= mpc52xx_ata_dev_select,
>   	.set_piomode		= mpc52xx_ata_set_piomode,
>   	.set_dmamode		= mpc52xx_ata_set_dmamode,

WBR, Sergei
