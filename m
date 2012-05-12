Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853Ab2ELMhM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 08:37:12 -0400
Received: from mx01.sz.bfs.de ([194.94.69.103]:42874 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755802Ab2ELMgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 08:36:46 -0400
Message-ID: <4FAE595A.6010605@bfs.de>
Date: Sat, 12 May 2012 14:36:42 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] iommu: off by one in dmar_get_fault_reason()
References: <20120512105935.GA19472@elgon.mountain>
In-Reply-To: <20120512105935.GA19472@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 12.05.2012 12:59, schrieb Dan Carpenter:
> fault_reason == ARRAY_SIZE(irq_remap_fault_reasons) + 0x20 - 0x20 is one
> past the end of the array.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
> index 5ef65cf..9390f3f 100644
> --- a/drivers/iommu/dmar.c
> +++ b/drivers/iommu/dmar.c
> @@ -1057,7 +1057,7 @@ static const char *irq_remap_fault_reasons[] =
>  
>  const char *dmar_get_fault_reason(u8 fault_reason, int *fault_type)
>  {
> -	if (fault_reason >= 0x20 && (fault_reason <= 0x20 +
> +	if (fault_reason >= 0x20 && (fault_reason < 0x20 +
>  				     ARRAY_SIZE(irq_remap_fault_reasons))) {
>  		*fault_type = INTR_REMAP;
>  		return irq_remap_fault_reasons[fault_reason - 0x20];

perhaps this is more readable:
if (fault_reason >= 0x20 && (fault_reason - 0x20 < ARRAY_SIZE(irq_remap_fault_reasons)))

re,
 wh
