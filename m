Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab0HAXsa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 19:48:30 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37224 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab0HAXs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 19:48:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=xkJ56B80ezZx1DezdLFWr/3xwOFZxr5dkD/TJHxjEiX0aJRR+vzXotgk9erX5CGPIs
         dSqQJVXynEtQHcR2HnqSz7LjbNzrBgsEvzg94opLr1ntp9EffDi6l/wIRGM8t7SerATU
         s439275iKttiYLlJZzy2GfspWA48DzdNJUY1U=
Message-ID: <4C5607C8.4090708@pobox.com>
Date: Sun, 01 Aug 2010 19:48:24 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Thunderbird/3.0.6
MIME-Version: 1.0
To: Peter Huewe <PeterHuewe@gmx.de>
CC: Kernel Janitors <kernel-janitors@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Sergei Shtylyov <sshtylyov@ru.mvista.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/25] ata: Convert pci_table entries to PCI_VDEVICE (if
 PCI_ANY_ID is used)
References: <201007152039.44324.PeterHuewe@gmx.de>
In-Reply-To: <201007152039.44324.PeterHuewe@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2010 02:39 PM, Peter Huewe wrote:
> From: Peter Huewe<peterhuewe@gmx.de>
>
> This patch converts pci_table entries, where .subvendor=PCI_ANY_ID and
> .subdevice=PCI_ANY_ID, .class=0 and .class_mask=0, to use the
> PCI_VDEVICE macro, and thus improves readability.
>
> Signed-off-by: Peter Huewe<peterhuewe@gmx.de>
> ---
>   drivers/ata/pata_scc.c |    3 +--
>   1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/ata/pata_scc.c b/drivers/ata/pata_scc.c
> index d9db3f8..fe36966 100644
> --- a/drivers/ata/pata_scc.c
> +++ b/drivers/ata/pata_scc.c
> @@ -168,8 +168,7 @@ static const unsigned long JCACTSELtbl[2][7] = {
>   };
>
>   static const struct pci_device_id scc_pci_tbl[] = {
> -	{PCI_VENDOR_ID_TOSHIBA_2, PCI_DEVICE_ID_TOSHIBA_SCC_ATA,
> -	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
> +	{ PCI_VDEVICE(TOSHIBA_2, PCI_DEVICE_ID_TOSHIBA_SCC_ATA), 0},
>   	{ }	/* terminate list */

applied

I would prefer to leave ata_piix as it is, though.  It's nice and 
manageable :)


