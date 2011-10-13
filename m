Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab1JMMGV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 08:06:21 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56811 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab1JMMGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 08:06:20 -0400
Message-ID: <4E96D406.6020202@mvista.com>
Date: Thu, 13 Oct 2011 16:05:26 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_artop: add Power Management support
References: <201110131259.35664.bzolnier@gmail.com>
In-Reply-To: <201110131259.35664.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 13-10-2011 14:59, Bartlomiej Zolnierkiewicz wrote:

> From: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> Subject: [PATCH] pata_artop: add Power Management support

> Fixes IDE ->  libata regression.

> There shouldn't be any problems with it as corresponding IDE's host
> driver (aec62xx) has been supporting PCI Power Management since
> Oct 10 2008 (commit feb22b7f "ide: add proper PCI PM support (v2)")
> and IDE PM since Jun 14 2003 (patch v2.5.73 "ide: Power Management").

> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> ---
> earlier references:
> https://lkml.org/lkml/2009/11/25/314

>   drivers/ata/pata_artop.c |   81 +++++++++++++++++++++++++++++++----------------
>   1 file changed, 54 insertions(+), 27 deletions(-)

> Index: b/drivers/ata/pata_artop.c
> ===================================================================
> --- a/drivers/ata/pata_artop.c
> +++ b/drivers/ata/pata_artop.c
[...]
> @@ -313,6 +313,33 @@ static struct ata_port_operations artop6
>   	.prereset		= artop62x0_pre_reset,
>   };
>
> +static void atp8xx_fixup(struct pci_dev *pdev)
> +{
> +	if (pdev->device == 0x0005)

    This is asking to be *switch* statement instead.

> +		/* BIOS may have left us in UDMA, clear it before libata probe */
> +		pci_write_config_byte(pdev, 0x54, 0);
> +	else if (pdev->device == 0x0008 || pdev->device == 0x0009) {
> +		u8 reg;
> +
> +		/* Mac systems come up with some registers not set as we
> +		   will need them */

    Comment style could be improved...

WBR, Sergei
