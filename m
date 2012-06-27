Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231Ab2F0Wgc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 18:36:32 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:48669 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab2F0Wga convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 18:36:30 -0400
MIME-Version: 1.0
In-Reply-To: <20120627090824.GR31212@elgon.mountain>
References: <20120627085800.GA3007@mwanda>
	<20120627090824.GR31212@elgon.mountain>
Date: Wed, 27 Jun 2012 15:36:29 -0700
Message-ID: <CAHtARFFsPbpZUBkj3d8UDXiHrKBqGCFOGu7oLhy9qfRapF7RMQ@mail.gmail.com>
Subject: Re: [patch -resend] [SCSI] megaraid: cleanup type issue in mega_build_cmd()
From: adam radford <aradford@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 2:08 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On 64 bit systems the current code sets 32 bits of "seg" and leaves the
> other 32 uninitialized.  It doesn't matter since the variable is never
> used.  But it's still messy and we should fix it.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Originally sent on Fri, 2 Mar 2012.
>
> diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
> index 4d39a9f..97825f1 100644
> --- a/drivers/scsi/megaraid.c
> +++ b/drivers/scsi/megaraid.c
> @@ -524,7 +524,7 @@ mega_build_cmd(adapter_t *adapter, Scsi_Cmnd *cmd, int *busy)
>        mega_passthru   *pthru;
>        scb_t   *scb;
>        mbox_t  *mbox;
> -       long    seg;
> +       u32     seg;
>        char    islogical;
>        int     max_ldrv_num;
>        int     channel = 0;
> @@ -858,7 +858,7 @@ mega_build_cmd(adapter_t *adapter, Scsi_Cmnd *cmd, int *busy)
>
>                        /* Calculate Scatter-Gather info */
>                        mbox->m_out.numsgelements = mega_build_sglist(adapter, scb,
> -                                       (u32 *)&mbox->m_out.xferaddr, (u32 *)&seg);
> +                                       (u32 *)&mbox->m_out.xferaddr, &seg);
>
>                        return scb;
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Acked-by: Adam Radford <aradford@gmail.com>
