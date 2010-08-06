Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760598Ab0HFHub (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 03:50:31 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55508 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab0HFHu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 03:50:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=ILCPFuMOoDFIIcKw2DBdIF3jlZw+bveyBgCxs2jEjKC7sZZNPdPAgTfinGdA6PvJ4A
         v/+Mbts1cTy8MJb2Fq7jptPXwej7zOKsCZj0ymS8NsXsyO88p0LMKyJShIlG4XPb4n9k
         vy3QpUrJkUiOqBQtTxmbc0rGQk+ZgtF/szZ1g=
Date: Fri, 6 Aug 2010 09:49:53 +0200
From: Dan Carpenter <error27@gmail.com>
To: Julia Lawall <julia@diku.dk>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, nick.cheng@areca.com.tw
Subject: Re: [PATCH 9/42] drivers/scsi: Adjust confusing if indentation
Message-ID: <20100806074920.GR9031@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Julia Lawall <julia@diku.dk>,
	"James E.J. Bottomley" <James.Bottomley@suse.de>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org, nick.cheng@areca.com.tw
References: <Pine.LNX.4.64.1008052219190.31692@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1008052219190.31692@ask.diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This should go to Nick Cheng.  He would know about the arcmsr driver.

regards,
dan carpenter

On Thu, Aug 05, 2010 at 10:19:36PM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Outdent the code following the if.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @r disable braces4@
> position p1,p2;
> statement S1,S2;
> @@
> 
> (
> if (...) { ... }
> |
> if (...) S1@p1 S2@p2
> )
> 
> @script:python@
> p1 << r.p1;
> p2 << r.p2;
> @@
> 
> if (p1[0].column == p2[0].column):
>   cocci.print_main("branch",p1)
>   cocci.print_secs("after",p2)
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
> This might be the wrong fix, however it doesn't change the current semantics.
> 
>  drivers/scsi/arcmsr/arcmsr_hba.c    |    4 ++--
>  drivers/scsi/mpt2sas/mpt2sas_base.c |    2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
> index 95a895d..c4e5cdc 100644
> --- a/drivers/scsi/arcmsr/arcmsr_hba.c
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c
> @@ -877,8 +877,8 @@ static void arcmsr_report_ccb_state(struct AdapterControlBlock *acb,
>  	if (!error) {
>  		if (acb->devstate[id][lun] == ARECA_RAID_GONE)
>  			acb->devstate[id][lun] = ARECA_RAID_GOOD;
> -			ccb->pcmd->result = DID_OK << 16;
> -			arcmsr_ccb_complete(ccb);
> +		ccb->pcmd->result = DID_OK << 16;
> +		arcmsr_ccb_complete(ccb);
>  	}else{
>  		switch (ccb->arcmsr_cdb.DeviceStatus) {
>  		case ARCMSR_DEV_SELECT_TIMEOUT: {
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
> index 57bcd5c..12faf64 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_base.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
> @@ -534,7 +534,7 @@ _base_display_event_data(struct MPT2SAS_ADAPTER *ioc,
>  		if (event_data->DiscoveryStatus)
>  			printk("discovery_status(0x%08x)",
>  			    le32_to_cpu(event_data->DiscoveryStatus));
> -			printk("\n");
> +		printk("\n");
>  		return;
>  	}
>  	case MPI2_EVENT_SAS_BROADCAST_PRIMITIVE:
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
