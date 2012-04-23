Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab2DWPBX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 11:01:23 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:7006 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518Ab2DWPBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 11:01:21 -0400
Message-ID: <4F956EBF.7020506@hp.com>
Date: Mon, 23 Apr 2012 10:01:19 -0500
From: Mike Miller <mike.miller@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: Chirag Kantharia <chirag.kantharia@hp.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        ISS StorageDev <iss_storagedev@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/block/cpqarray.c: add missing cmd_free
References: <1335086112-10528-1-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1335086112-10528-1-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2012 04:15 AM, Julia Lawall wrote:
> From: Julia Lawall<Julia.Lawall@lip6.fr>
>
> Call cmd_free(h, c, 0); before leaving the function as done on all other
> exit paths.
>
> Signed-off-by: Julia Lawall<Julia.Lawall@lip6.fr>
Acked-by: Mike Miller <mike.miller@hp.com>
>
> ---
>   drivers/block/cpqarray.c |    1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/block/cpqarray.c b/drivers/block/cpqarray.c
> index 9125bbe..db6f15d 100644
> --- a/drivers/block/cpqarray.c
> +++ b/drivers/block/cpqarray.c
> @@ -1334,6 +1334,7 @@ static int ida_ctlr_ioctl(ctlr_info_t *h, int dsk, ida_ioctl_t *io)
>   	case READ_FLASH_ROM:
>   		if (copy_to_user(io->sg[0].addr, p, io->sg[0].size)) {
>   			kfree(p);
> +			cmd_free(h, c, 0);
>   			return -EFAULT;
>   		}
>   		/* fall through and free p */
>

