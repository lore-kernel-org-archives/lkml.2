Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759353Ab2BJNxw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 08:53:52 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:56418 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757510Ab2BJNxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 08:53:51 -0500
MIME-Version: 1.0
In-Reply-To: <20120210135253.12442.95497.stgit@bob.linux.org.uk>
References: <20120210134929.12442.59041.stgit@bob.linux.org.uk>
	<20120210135253.12442.95497.stgit@bob.linux.org.uk>
Date: Fri, 10 Feb 2012 21:53:50 +0800
Message-ID: <CAJd=RBAYtrQZBB3LHX=9xFru=r1XAuZrm1kL1siMKvBmCuuO9A@mail.gmail.com>
Subject: Re: [PATCH 3/6] sep: Add interfaces for the new functions
From: Hillf Danton <dhillf@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org, mark.a.allyn@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q1ADrvOi018039

Hello Alan

On Fri, Feb 10, 2012 at 9:52 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> From: Mark A. Allyn <mark.a.allyn@intel.com>
>
> [This is picked out of the differences between the upstream driver and
>  the staging driver. I'm resolving the differences as a series of updates -AC]
>
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
>
>  drivers/staging/sep/sep_main.c |   60 +++++++++++++++++++++++++++++++++-------
>  1 files changed, 49 insertions(+), 11 deletions(-)
>
>
> diff --git a/drivers/staging/sep/sep_main.c b/drivers/staging/sep/sep_main.c
> index 7d7cb48..1fcabca 100644
> --- a/drivers/staging/sep/sep_main.c
> +++ b/drivers/staging/sep/sep_main.c
> @@ -3067,9 +3067,13 @@ static long sep_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>
>        switch (cmd) {
>        case SEP_IOCSENDSEPCOMMAND:
> +               dev_dbg(&sep->pdev->dev,
> +                       "[PID%d] SEP_IOCSENDSEPCOMMAND start\n",
> +                       current->pid);
>                if (1 == test_bit(SEP_LEGACY_SENDMSG_DONE_OFFSET,
>                                  &call_status->status)) {
> -                       dev_dbg(&sep->pdev->dev, "[PID%d] send msg already done\n",
> +                       dev_warn(&sep->pdev->dev,
> +                               "[PID%d] send msg already done\n",
>                                current->pid);
>                        error = -EPROTO;
>                        goto end_function;
> @@ -3079,37 +3083,71 @@ static long sep_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>                if (!error)
>                        set_bit(SEP_LEGACY_SENDMSG_DONE_OFFSET,
>                                &call_status->status);
> -               dev_dbg(&sep->pdev->dev, "[PID%d] SEP_IOCSENDSEPCOMMAND end\n",
> +               dev_dbg(&sep->pdev->dev,
> +                       "[PID%d] SEP_IOCSENDSEPCOMMAND end\n",
>                        current->pid);
>                break;
>        case SEP_IOCENDTRANSACTION:
> +               dev_dbg(&sep->pdev->dev,
> +                       "[PID%d] SEP_IOCENDTRANSACTION start\n",
> +                       current->pid);
>                error = sep_end_transaction_handler(sep, dma_ctx, call_status,
> -                       my_queue_elem);
> -               dev_dbg(&sep->pdev->dev, "[PID%d] SEP_IOCENDTRANSACTION end\n",
> +                                                   my_queue_elem);
> +               dev_dbg(&sep->pdev->dev,
> +                       "[PID%d] SEP_IOCENDTRANSACTION end\n",
>                        current->pid);
>                break;
>        case SEP_IOCPREPAREDCB:
> +               dev_dbg(&sep->pdev->dev,
> +                       "[PID%d] SEP_IOCPREPAREDCB start\n",
> +                       current->pid);
> +       case SEP_IOCPREPAREDCB_SECURE_DMA:
> +               dev_dbg(&sep->pdev->dev,
> +                       "[PID%d] SEP_IOCPREPAREDCB_SECURE_DMA start\n",
> +                       current->pid);
>                if (1 == test_bit(SEP_LEGACY_SENDMSG_DONE_OFFSET,
>                                  &call_status->status)) {
> -                       dev_dbg(&sep->pdev->dev,
> -                               "[PID%d] dcb preparation needed before send msg\n",
> +                       dev_warn(&sep->pdev->dev,
> +                               "[PID%d] dcb prep needed before send msg\n",
>                                current->pid);
>                        error = -EPROTO;
>                        goto end_function;
>                }
>
>                if (!arg) {
> -                       dev_dbg(&sep->pdev->dev,
> -                               "[PID%d] dcb prep null arg\n", current->pid);
> -                       error = -EINVAL;
> +                       dev_warn(&sep->pdev->dev,
> +                               "[PID%d] dcb null arg\n", current->pid);
> +                       error = EINVAL;

Typo if error = -EPROTO allowed?
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
