Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402Ab1LGG5N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 01:57:13 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:37836 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab1LGG5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 01:57:12 -0500
X-AuditID: cbfee61b-b7b95ae00000198b-f6-4edf0e45223a
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Thomas Meyer'" <thomas@m3y3r.de>, ben-linux@fluff.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <1321569820.1624.268.camel@localhost.localdomain>
In-reply-to: <1321569820.1624.268.camel@localhost.localdomain>
Subject: RE: [PATCH] ARM: SAMSUNG: Use kmemdup rather than duplicating its
 implementation
Date: Wed, 07 Dec 2011 15:57:07 +0900
Message-id: <03e001ccb4ad$6f76a490$4e63edb0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Acyl1RQO/FM1ZQtQTvesvhQpLZ7cgwO2EVcA
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Meyer wrote:
> 
> The semantic patch that makes this change is available
> in scripts/coccinelle/api/memdup.cocci.
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> ---
> 
> diff -u -p a/arch/arm/plat-s3c24xx/dma.c b/arch/arm/plat-s3c24xx/dma.c
> --- a/arch/arm/plat-s3c24xx/dma.c 2011-11-07 19:37:20.736205210 +0100
> +++ b/arch/arm/plat-s3c24xx/dma.c 2011-11-08 11:03:41.719762852 +0100
> @@ -1437,11 +1437,10 @@ int __init s3c24xx_dma_init_map(struct s
>  	size_t map_sz = sizeof(*nmap) * sel->map_size;
>  	int ptr;
> 
> -	nmap = kmalloc(map_sz, GFP_KERNEL);
> +	nmap = kmemdup(sel->map, map_sz, GFP_KERNEL);
>  	if (nmap == NULL)
>  		return -ENOMEM;
> 
> -	memcpy(nmap, sel->map, map_sz);
>  	memcpy(&dma_sel, sel, sizeof(*sel));
> 
>  	dma_sel.map = nmap;

Yes, looks ok to me, will apply.
Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

