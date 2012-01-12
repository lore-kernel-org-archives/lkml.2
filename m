Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab2ALUI5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 15:08:57 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:58378 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753848Ab2ALUIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 15:08:55 -0500
X-IronPort-AV: E=Sophos;i="4.71,500,1320620400"; 
   d="scan'208";a="139021225"
Date: Thu, 12 Jan 2012 21:08:52 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: lawall@pl-59034.rocq.inria.fr
To: James Smart <james.smart@emulex.com>
cc: Julia Lawall <Julia.Lawall@lip6.fr>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] drivers/scsi/lpfc/lpfc_sli.c: convert GFP_KERNEL to
 GFP_ATOMIC
In-Reply-To: <4F0F3BDC.10103@emulex.com>
Message-ID: <alpine.DEB.2.00.1201122108320.25187@pl-59034.rocq.inria.fr>
References: <1326102050-30265-2-git-send-email-Julia.Lawall@lip6.fr> <4F0F3BDC.10103@emulex.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jan 2012, James Smart wrote:

> Julia,
>
> We actually do not want any ATOMIC allocations if we can avoid them.  We 
> reworked the calling sequence to deal with the locks being held. The change 
> will be in the next patch set.
>
> As such - Nack on the patch.

No problem.  It was more a bug report than a real patch.

thanks,
julia

> -- james s
>
>
>
> On 1/9/2012 4:40 AM, Julia Lawall wrote:
>> From: Julia Lawall<julia.lawall@lip6.fr>
>> 
>> The function is called with locks held and thus should not use GFP_KERNEL.
>> 
>> The semantic patch that makes this report is available
>> in scripts/coccinelle/locks/call_kern.cocci.
>> 
>> More information about semantic patching is available at
>> http://coccinelle.lip6.fr/
>> 
>> Signed-off-by: Julia Lawall<julia.lawall@lip6.fr>
>> 
>> ---
>>   drivers/scsi/lpfc/lpfc_sli.c |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
>> index 23a2759..622d24f 100644
>> --- a/drivers/scsi/lpfc/lpfc_sli.c
>> +++ b/drivers/scsi/lpfc/lpfc_sli.c
>> @@ -601,7 +601,7 @@ __lpfc_set_rrq_active(struct lpfc_hba *phba, struct 
>> lpfc_nodelist *ndlp,
>>   	if (test_and_set_bit(xritag, ndlp->active_rrqs.xri_bitmap))
>>   		goto out;
>> 
>> -	rrq = mempool_alloc(phba->rrq_pool, GFP_KERNEL);
>> +	rrq = mempool_alloc(phba->rrq_pool, GFP_ATOMIC);
>>   	if (rrq) {
>>   		rrq->send_rrq = send_rrq;
>>   		rrq->xritag = xritag;
>> 
>> 
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
