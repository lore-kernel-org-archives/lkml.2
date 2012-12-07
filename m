Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab2LGIl7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 03:41:59 -0500
Received: from mail.sf-mail.de ([62.27.20.61]:52961 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754692Ab2LGIl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 03:41:58 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Fri, 07 Dec 2012 09:41:56 +0100
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>,
        Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, <support@lsi.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        <DL-MPTFusionLinux@lsi.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: Re: [patch] [SCSI] mpt3sas: cut and paste bug storing trigger mpi
In-Reply-To: <20121207062801.GD18220@elgon.mountain>
References: <20121207062801.GD18220@elgon.mountain>
Message-ID: <953b00ff89996c4a3681b3c8f425462b@sf-mail.de>
User-Agent: Roundcube Webmail/0.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ioc->diag_trigger_mpi is an SL_WH_MPI_TRIGGERS_T struct.
>
> There is a cut and paste error here and SL_WH_EVENT_TRIGGERS_T is 
> used
> instead of SL_WH_MPI_TRIGGERS_T.  Since the SL_WH_EVENT_TRIGGERS_T is
> smaller than SL_WH_MPI_TRIGGERS_T, it means we only clear part of the
> buffer.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Only needed in linux-next.
>
> This is a static analysis patch.  Even though I'm pretty sure it's
> correct, I'm not able to test it.
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> index 8af944d..3e35e64 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> @@ -3136,7 +3136,7 @@ _ctl_diag_trigger_mpi_store(struct device 
> *cdev,
>  	spin_lock_irqsave(&ioc->diag_trigger_lock, flags);
>  	sz = min(sizeof(struct SL_WH_MPI_TRIGGERS_T), count);
>  	memset(&ioc->diag_trigger_mpi, 0,
> -	    sizeof(struct SL_WH_EVENT_TRIGGERS_T));
> +	    sizeof(struct SL_WH_MPI_TRIGGERS_T));
>  	memcpy(&ioc->diag_trigger_mpi, buf, sz);
>  	if (ioc->diag_trigger_mpi.ValidEntries > NUM_VALID_ENTRIES)
>  		ioc->diag_trigger_mpi.ValidEntries = NUM_VALID_ENTRIES;

Then just use sizeof(ioc->diag_trigger_mpi), then it's irrelevant how 
that type is ever called.

Eike
