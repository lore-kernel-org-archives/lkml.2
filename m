Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048Ab2F0Wg6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 18:36:58 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:45605 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755710Ab2F0Wg5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 18:36:57 -0400
MIME-Version: 1.0
In-Reply-To: <20120627090030.GC31212@elgon.mountain>
References: <20120627085800.GA3007@mwanda>
	<20120627090030.GC31212@elgon.mountain>
Date: Wed, 27 Jun 2012 15:36:55 -0700
Message-ID: <CAHtARFGG4HxL7J40o341gBOg8+GunYEGyP0SrBK_w3pH3v6+PA@mail.gmail.com>
Subject: Re: [patch -resend] [SCSI] megaraid: remove a spurious IRQ enable
From: adam radford <aradford@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 2:00 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> We took this lock with spin_lock() so we should unlock it with
> spin_unlock() instead of spin_unlock_irq().  This was introduced in
> f2c8dc402b "[SCSI] megaraid_mbox: remove scsi_assign_lock usage".
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> This was originally sent on Sat, 30 Jul 2011.  I have cleaned up the
> commit message a bit and added Christoph to the CC list.
>
> diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
> index 35bd138..54b1c5b 100644
> --- a/drivers/scsi/megaraid/megaraid_mbox.c
> +++ b/drivers/scsi/megaraid/megaraid_mbox.c
> @@ -2731,7 +2731,7 @@ megaraid_reset_handler(struct scsi_cmnd *scp)
>        }
>
>  out:
> -       spin_unlock_irq(&adapter->lock);
> +       spin_unlock(&adapter->lock);
>        return rval;
>  }
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Acked-by: Adam Radford <aradford@gmail.com>
