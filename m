Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292Ab0KNU3z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 15:29:55 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44994 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932269Ab0KNU3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 15:29:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=PJQenjQgOWAoEIzafmY7VdeQjHg3AuEcpV83s0YntZUm2OYPLx1Dgn2bl2XxfdtdoA
         YnTVlhTzdMU/nqq/RIlAoKUqRo36Eqo92rFF8bb2nxB3pUZ8+NdVoBEAuwTUo0AGEN2J
         yPsNY/hwi8dp57oI6FNambFB2RBwTNVSljl7Y=
Subject: Re: [PATCH] net: bnx2x: fix error value sign
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-janitors@vger.kernel.org, Eilon Greenstein <eilong@broadcom.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1289765315-6028-1-git-send-email-segoon@openwall.com>
References: <1289765315-6028-1-git-send-email-segoon@openwall.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Nov 2010 21:29:43 +0100
Message-ID: <1289766583.2743.144.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 14 novembre 2010 à 23:08 +0300, Vasiliy Kulikov a écrit :
> bnx2x_init_one() should return negative value on error.
> By mistake it returns ENODEV instead of -ENODEV.
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
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

I remember sending same patch in the past... it was lost somehow...



