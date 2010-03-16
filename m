Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937924Ab0CPRMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 13:12:08 -0400
Received: from exht1.emulex.com ([138.239.113.183]:25564 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933193Ab0CPRMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 13:12:06 -0400
Message-ID: <4B9FBBCE.6060401@emulex.com>
Date: Tue, 16 Mar 2010 13:11:42 -0400
From: James Smart <james.smart@emulex.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: "James.Bottomley@suse.de" <James.Bottomley@suse.de>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jirislaby@gmail.com" <jirislaby@gmail.com>
Subject: Re: [PATCH 2/3] SCSI: lpfc, fix lock imbalances
References: <1268753039-17214-1-git-send-email-jslaby@suse.cz> <1268753039-17214-2-git-send-email-jslaby@suse.cz>
In-Reply-To: <1268753039-17214-2-git-send-email-jslaby@suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-By:  James Smart <james.smart@emulex.com>

-- james s


Jiri Slaby wrote:
> Stanse found that two error paths in lpfc_bsg_rport_els_cmp and
> lpfc_issue_ct_rsp_cmp omits to unlock phba->ct_ev_lock. It is
> because they wrongly unlock phba->hbalock instead. Fix that.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: James Smart <james.smart@emulex.com>
> Cc: James Bottomley <James.Bottomley@suse.de>
> ---
>  drivers/scsi/lpfc/lpfc_bsg.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
> index 692c29f..992efb1 100644
> --- a/drivers/scsi/lpfc/lpfc_bsg.c
> +++ b/drivers/scsi/lpfc/lpfc_bsg.c
> @@ -432,7 +432,7 @@ lpfc_bsg_rport_els_cmp(struct lpfc_hba *phba,
>  	dd_data = cmdiocbq->context1;
>  	/* normal completion and timeout crossed paths, already done */
>  	if (!dd_data) {
> -		spin_unlock_irqrestore(&phba->hbalock, flags);
> +		spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
>  		return;
>  	}
>  
> @@ -1195,7 +1195,7 @@ lpfc_issue_ct_rsp_cmp(struct lpfc_hba *phba,
>  	dd_data = cmdiocbq->context1;
>  	/* normal completion and timeout crossed paths, already done */
>  	if (!dd_data) {
> -		spin_unlock_irqrestore(&phba->hbalock, flags);
> +		spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
>  		return;
>  	}
>  
