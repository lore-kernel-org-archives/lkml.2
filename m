Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab2JPARn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 20:17:43 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36762 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab2JPARm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 20:17:42 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <507CA784.6010701@jp.fujitsu.com>
Date: Tue, 16 Oct 2012 09:17:08 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: <linux-acpi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] [resend] ACPI: Fix memory leak in acpi_bind_one() (fwd)
References: <alpine.LNX.2.00.1210152049550.1038@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1210152049550.1038@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-15 at 20:51 +0200, Jesper Juhl wrote:
> Ok, so I had a little problem with my mail servers clock that caused the
> mail below to be timestamped a few years in the past, so I assume noone
> saw it - thus, resending.
>
> --
> Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
> Don't top-post http://www.catb.org/jargon/html/T/top-post.html
> Plain text mails only, please.
>
>
> ---------- Forwarded message ----------
> Date: Sun, 9 Nov 2008 14:38:30 +0100 (CET)
> From: Jesper Juhl <jj@chaosbits.net>
> To: linux-acpi@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>
> Subject: [PATCH] ACPI: Fix memory leak in acpi_bind_one()
>
> Memory is allocated with kzalloc() and assigned to
> 'physical_node'. Then 'physical_node->node_id' is initialized with a
> call to 'find_first_zero_bit()', if that results in a value greater
> than ACPI_MAX_PHYSICAL_NODE we'll end up jumping to the 'err:' label
> and there leave the function and let 'physical_node' go out of scope
> and leak the memory we allocated.
> This patch fixes the leak by simply freeing the unused/unneeded memory
> pointed to by 'physical_node' just before we jump to 'err:'.
>
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Looks good to me.

Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Thanks,
Yasuaki Ishimatsu

> ---
>  drivers/acpi/glue.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/acpi/glue.c b/drivers/acpi/glue.c
> index d1a2d74..0837308 100644
> --- a/drivers/acpi/glue.c
> +++ b/drivers/acpi/glue.c
> @@ -159,6 +159,7 @@ static int acpi_bind_one(struct device *dev, acpi_handle handle)
>  	if (physical_node->node_id >= ACPI_MAX_PHYSICAL_NODE) {
>  		retval = -ENOSPC;
>  		mutex_unlock(&acpi_dev->physical_node_lock);
> +		kfree(physical_node);
>  		goto err;
>  	}
>
> --
> 1.7.1
>
>


