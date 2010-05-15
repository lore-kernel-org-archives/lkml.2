Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab0EOVdd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 17:33:33 -0400
Received: from nat.nue.novell.com ([195.135.221.3]:46616 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab0EOVdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 17:33:32 -0400
Message-ID: <4BEF1328.8040306@suse.de>
Date: Sun, 16 May 2010 01:33:28 +0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 11/37] drivers/acpi: Use kmemdup
References: <Pine.LNX.4.64.1005152316030.21345@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.1005152316030.21345@ask.diku.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julia,

Acked-by: Alexey Starikovskiy <astarikovskiy@suse.de>

Thanks,
Alex.


16.05.2010 01:16, Julia Lawall пишет:
> From: Julia Lawall<julia@diku.dk>
>
> Use kmemdup when some other buffer is immediately copied into the
> allocated region.
>
> A simplified version of the semantic patch that makes this change is as
> follows: (http://coccinelle.lip6.fr/)
>
> //<smpl>
> @@
> expression from,to,size,flag;
> statement S;
> @@
>
> -  to = \(kmalloc\|kzalloc\)(size,flag);
> +  to = kmemdup(from,size,flag);
>     if (to==NULL || ...) S
> -  memcpy(to, from, size);
> //</smpl>
>
> Signed-off-by: Julia Lawall<julia@diku.dk>
>
> ---
>   drivers/acpi/ec.c |    3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff -u -p a/drivers/acpi/ec.c b/drivers/acpi/ec.c
> --- a/drivers/acpi/ec.c
> +++ b/drivers/acpi/ec.c
> @@ -1027,10 +1027,9 @@ int __init acpi_ec_ecdt_probe(void)
>   		/* Don't trust ECDT, which comes from ASUSTek */
>   		if (!EC_FLAGS_VALIDATE_ECDT)
>   			goto install;
> -		saved_ec = kmalloc(sizeof(struct acpi_ec), GFP_KERNEL);
> +		saved_ec = kmemdup(boot_ec, sizeof(struct acpi_ec), GFP_KERNEL);
>   		if (!saved_ec)
>   			return -ENOMEM;
> -		memcpy(saved_ec, boot_ec, sizeof(struct acpi_ec));
>   	/* fall through */
>   	}
>

