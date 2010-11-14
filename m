Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974Ab0KNU06 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 15:26:58 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:2718 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756933Ab0KNU04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 15:26:56 -0500
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Subject: Re: [PATCH] net: bnx2x: fix error value sign
From: "Eilon Greenstein" <eilong@broadcom.com>
Reply-to: eilong@broadcom.com
To: "Vasiliy Kulikov" <segoon@openwall.com>
cc: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1289765315-6028-1-git-send-email-segoon@openwall.com>
References: <1289765315-6028-1-git-send-email-segoon@openwall.com>
Organization: Broadcom
Date: Sun, 14 Nov 2010 22:26:43 +0200
Message-ID: <1289766403.29137.0.camel@lb-tlvb-eilong.il.broadcom.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3
X-WSS-ID: 60FE99803P08010070-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-11-14 at 12:08 -0800, Vasiliy Kulikov wrote:
> bnx2x_init_one() should return negative value on error.
> By mistake it returns ENODEV instead of -ENODEV.
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Thanks Vasiliy!

Acked-by: Eilon Greenstein <eilong@broadcom.com>
> ---
>  Compile tested.
> 
>  drivers/net/bnx2x/bnx2x_main.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/bnx2x/bnx2x_main.c b/drivers/net/bnx2x/bnx2x_main.c
> index 4a6f0ea..be52edc 100644
> --- a/drivers/net/bnx2x/bnx2x_main.c
> +++ b/drivers/net/bnx2x/bnx2x_main.c
> @@ -9064,7 +9064,7 @@ static int __devinit bnx2x_init_one(struct pci_dev *pdev,
>  	default:
>  		pr_err("Unknown board_type (%ld), aborting\n",
>  			   ent->driver_data);
> -		return ENODEV;
> +		return -ENODEV;
>  	}
>  
>  	cid_count += CNIC_CONTEXT_USE;




