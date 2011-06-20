Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751006Ab1FTIQc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 04:16:32 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54475 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab1FTIQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 04:16:28 -0400
Message-ID: <4DFF019B.8030605@ru.mvista.com>
Date: Mon, 20 Jun 2011 12:15:23 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Yuan-Hsin Chen <yuanlmm@gmail.com>
CC: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        tj@kernel.org, sshtylyov@mvista.com,
        Yuan-Hsin Chen <yhchen@faraday-tech.com>
Subject: Re: [PATCH v4] ahci: move ahci_sb600_softreset to libahci.c and rename
 it
References: <20110617120704.GH2611@htj.dyndns.org> <1308557202-1895-1-git-send-email-yuanlmm@gmail.com>
In-Reply-To: <1308557202-1895-1-git-send-email-yuanlmm@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 20-06-2011 12:06, Yuan-Hsin Chen wrote:

> From: Yuan-Hsin Chen<yhchen@faraday-tech.com>

> ahci_sb600_softreset was in ahci.c. This function is used
> to fix soft reset failure and renames as ahci_pmp_retry_srst_softreset
> in libahci.c.

> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
> index 71afe03..2de36b6 100644
> --- a/drivers/ata/ahci.c
> +++ b/drivers/ata/ahci.c
> @@ -79,8 +79,6 @@ enum board_ids {
>   };
>
>   static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
> -static int ahci_sb600_softreset(struct ata_link *link, unsigned int *class,
> -			  unsigned long deadline);
>   static int ahci_vt8251_hardreset(struct ata_link *link, unsigned int *class,
>   				 unsigned long deadline);
>   static int ahci_p5wdh_hardreset(struct ata_link *link, unsigned int *class,
> @@ -106,8 +104,7 @@ static struct ata_port_operations ahci_p5wdh_ops = {
>
>   static struct ata_port_operations ahci_sb600_ops = {
>   	.inherits		=&ahci_ops,
> -	.softreset		= ahci_sb600_softreset,
> -	.pmp_softreset		= ahci_sb600_softreset,
> +	.softreset		= ahci_pmp_retry_srst_softreset,

    I have to ask you again: have you tried to compile this?

> diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
> index d38c40f..0fd5a30 100644
> --- a/drivers/ata/libahci.c
> +++ b/drivers/ata/libahci.c
> @@ -82,6 +82,8 @@ static void ahci_pmp_attach(struct ata_port *ap);
>   static void ahci_pmp_detach(struct ata_port *ap);
>   static int ahci_softreset(struct ata_link *link, unsigned int *class,
>   			  unsigned long deadline);
> +static int ahci_pmp_retry_srst_softreset(struct ata_link *link, unsigned int *class,
> +			  unsigned long deadline);

    How come this is static if you reference it outside this module?

WBR, Sergei
