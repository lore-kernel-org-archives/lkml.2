Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467Ab2F0Hty (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 03:49:54 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38436 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754167Ab2F0Htx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 03:49:53 -0400
Message-ID: <1340783389.3175.11.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH] SCSI: Fix BLKSECTGET ioctl of sg device caculation
 mistake.
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Cong Meng <mc@linux.vnet.ibm.com>
Cc: stefanha@linux.vnet.ibm.com, linuxram@us.ibm.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Date: Wed, 27 Jun 2012 08:49:49 +0100
In-Reply-To: <1340782159-1587-1-git-send-email-mc@linux.vnet.ibm.com>
References: <1340782159-1587-1-git-send-email-mc@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-27 at 15:29 +0800, Cong Meng wrote:
> Fix BLKSECTGET ioctl of sg device caculation mistake.
> 
> Signed-off-by: Cong Meng <mc@linux.vnet.ibm.com>
> ---
>  drivers/scsi/sg.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index eacd46b..c424602 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -1070,7 +1070,7 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
>  			return -ENODEV;
>  		return scsi_ioctl(sdp->device, cmd_in, p);
>  	case BLKSECTGET:
> -		return put_user(queue_max_sectors(sdp->device->request_queue) * 512,
> +		return put_user(queue_max_sectors(sdp->device->request_queue),

Really, no.  This would break all existing user of the ioctl.

Even if you can find a document somewhere that says BLKSECTGET should
return sectors instead of bytes, we have to go with the ABI we've been
exporting for decades and fix up the document.

James


