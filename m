Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552Ab1APHJQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 02:09:16 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:58842 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab1APHJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 02:09:14 -0500
Subject: Re: [PATCH] [SCSI] target: Fix memory leak on error path
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <ada1v4d1k1j.fsf@cisco.com>
References: <ada1v4d1k1j.fsf@cisco.com>
Content-Type: text/plain
Date: Sat, 15 Jan 2011 23:09:11 -0800
Message-Id: <1295161751.22813.20.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-01-15 at 21:42 -0800, Roland Dreier wrote:
> If allocation of pt->pscsi_cdb fails, we need to free the just-allocated
> pt or else it will be leaked.
> 
> Signed-off-by: Roland Dreier <rolandd@cisco.com>

Good catch here.  Committed as dea3bdb0081 and pushed into
lio-core-2.6.git/linus-38-rc1 and scsi-post-merge-2.6.git/for-jejb.

Thanks Roland!

--nab

> ---
>  drivers/target/target_core_pscsi.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
> index 742d246..60a2509 100644
> --- a/drivers/target/target_core_pscsi.c
> +++ b/drivers/target/target_core_pscsi.c
> @@ -817,6 +817,7 @@ pscsi_alloc_task(struct se_cmd *cmd)
>  		if (!(pt->pscsi_cdb)) {
>  			printk(KERN_ERR "pSCSI: Unable to allocate extended"
>  					" pt->pscsi_cdb\n");
> +			kfree(pt);
>  			return NULL;
>  		}
>  	} else
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

