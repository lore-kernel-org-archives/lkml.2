Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188Ab1LHVPZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 16:15:25 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55712 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab1LHVPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 16:15:23 -0500
Message-ID: <4EE128E2.9050305@gentoo.org>
Date: Thu, 08 Dec 2011 23:15:14 +0200
From: Stratos Psomadakis <psomas@gentoo.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: linux-scsi@vger.kernel.org
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        JBottomley@parallels.com, matthew@wil.cx, Martin.vGagern@gmx.net
Subject: Re: [PATCH] scsi/sym53c8xx_2: Fix NULL pointer dereference in slave_destroy
References: <1322958234-9749-1-git-send-email-psomas@gentoo.org>
In-Reply-To: <1322958234-9749-1-git-send-email-psomas@gentoo.org>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2011 02:23 AM, psomas@gentoo.org wrote:
> From: Stratos Psomadakis <psomas@gentoo.org>
>
> sym53c8xx_slave_destroy unconditionally assumes that sym53c8xx_slave_alloc has
> succesesfully allocated a sym_lcb. This can lead to a NULL pointer dereference
> (exposed by commit 4e6c82b).
>
> Signed-off-by: Stratos Psomadakis <psomas@gentoo.org>
> Cc: stable@vger.kernel.org
> ---
>
>  drivers/scsi/sym53c8xx_2/sym_glue.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
> index b4543f5..76432f8 100644
> --- a/drivers/scsi/sym53c8xx_2/sym_glue.c
> +++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
> @@ -839,6 +839,10 @@ static void sym53c8xx_slave_destroy(struct scsi_device *sdev)
>  	struct sym_lcb *lp = sym_lp(tp, sdev->lun);
>  	unsigned long flags;
>  
> +	/* if slave_alloc returned before allocating a sym_lcb, return */
> +	if (!lp)
> +		return;
> +
>  	spin_lock_irqsave(np->s.host->host_lock, flags);
>  
>  	if (lp->busy_itlq || lp->busy_itl) {
Any comments/ack/nack on the patch?

Thanks,

-- 
Stratos Psomadakis
<psomas@gentoo.org>

