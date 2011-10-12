Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594Ab1JLKcy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 06:32:54 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55108 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab1JLKcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 06:32:53 -0400
Message-ID: <4E956C9F.6070304@mvista.com>
Date: Wed, 12 Oct 2011 14:31:59 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_atiixp: add proper ->prereset method
References: <201110111955.09320.bzolnier@gmail.com>
In-Reply-To: <201110111955.09320.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 11-10-2011 21:55, Bartlomiej Zolnierkiewicz wrote:

> From: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> Subject: [PATCH] pata_atiixp: add proper ->prereset method

> Fixes PCI access before PCI resources are allocated.

    Hm, didn't understand this...

> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> ---
> earlier references:
> https://lkml.org/lkml/2009/11/25/320

>   drivers/ata/pata_atiixp.c |   35 ++++++++++++++++++++++++++---------
>   1 file changed, 26 insertions(+), 9 deletions(-)

> Index: b/drivers/ata/pata_atiixp.c
> ===================================================================
> --- a/drivers/ata/pata_atiixp.c
> +++ b/drivers/ata/pata_atiixp.c
[...]
> @@ -235,16 +261,7 @@ static int atiixp_init_one(struct pci_de
>   		.udma_mask = ATA_UDMA5,
>   		.port_ops =&atiixp_port_ops
>   	};
> -	static const struct pci_bits atiixp_enable_bits[] = {
> -		{ 0x48, 1, 0x01, 0x00 },
> -		{ 0x48, 1, 0x08, 0x00 }
> -	};
>   	const struct ata_port_info *ppi[] = {&info,&info };
> -	int i;
> -
> -	for (i = 0; i<  2; i++)
> -		if (!pci_test_config_bits(pdev,&atiixp_enable_bits[i]))
> -			ppi[i] =&ata_dummy_port_info;

    But this seems more safe method than prereset() as it should really avoid 
accessing the disabled IDE ports (which blows up on non-x86)... didn't 
understand why this is incorrect...

WBR, Sergei
