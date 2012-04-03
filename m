Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab2DCPpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 11:45:49 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:48036 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835Ab2DCPps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 11:45:48 -0400
Message-ID: <4F7B1B2A.7060602@hp.com>
Date: Tue, 03 Apr 2012 10:45:46 -0500
From: Mike Miller <mike.miller@hp.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110927 Red Hat/3.1.15-1.el6_1 Thunderbird/3.1.15
MIME-Version: 1.0
To: Akinobu Mita <akinobu.mita@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ISS StorageDev <iss_storagedev@hp.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] hpsa: use check_signature
References: <1333431534-4595-1-git-send-email-akinobu.mita@gmail.com> <1333431534-4595-4-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1333431534-4595-4-git-send-email-akinobu.mita@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2012 12:38 AM, Akinobu Mita wrote:
> Use check_signature to find a signature in the mmio address.
>
> Signed-off-by: Akinobu Mita<akinobu.mita@gmail.com>
> Cc: Mike Miller<mike.miller@hp.com>
> Cc: iss_storagedev@hp.com
> Cc: "James E.J. Bottomley"<JBottomley@parallels.com>
> Cc: linux-scsi@vger.kernel.org

Acked-by: Mike Miller <mike.miller@hp.com>

> ---
>   drivers/scsi/hpsa.c |    5 +----
>   1 files changed, 1 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index ddbf5fe..c867eeb 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -3839,10 +3839,7 @@ static void __devinit hpsa_find_board_params(struct ctlr_info *h)
>
>   static inline bool hpsa_CISS_signature_present(struct ctlr_info *h)
>   {
> -	if ((readb(&h->cfgtable->Signature[0]) != 'C') ||
> -	    (readb(&h->cfgtable->Signature[1]) != 'I') ||
> -	    (readb(&h->cfgtable->Signature[2]) != 'S') ||
> -	    (readb(&h->cfgtable->Signature[3]) != 'S')) {
> +	if (!check_signature(h->cfgtable->Signature, "CISS", 4)) {
>   		dev_warn(&h->pdev->dev, "not a valid CISS config table\n");
>   		return false;
>   	}

