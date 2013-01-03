Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819Ab3ACSxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 13:53:17 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:46498 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017Ab3ACSxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 13:53:15 -0500
Message-ID: <50E5E153.9040801@mvista.com>
Date: Thu, 03 Jan 2013 22:51:47 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Hugh Daschbach <hugh.daschbach@enmotus.com>
CC: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v3.7.0] Add AHCI support for Enmotus Bobcat device.
References: <1357238107-4630-1-git-send-email-hugh.daschbach@enmotus.com>
In-Reply-To: <1357238107-4630-1-git-send-email-hugh.daschbach@enmotus.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 01/03/2013 09:35 PM, Hugh Daschbach wrote:

> Silicon does not support standard AHCI BAR assignment.  Add
> vendor/device exception to force BAR 2.

> Signed-off-by: Hugh Daschbach <hugh.daschbach@enmotus.com>
> ---
> Previously sent 14 Dec 2012.  Any feedback?
> Thanks,
> Hugh

>  drivers/ata/ahci.c | 6 ++++++
>  1 file changed, 6 insertions(+)

> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
> index 7862d17..3cb008f 100644
> --- a/drivers/ata/ahci.c
> +++ b/drivers/ata/ahci.c
[...]
> @@ -1101,6 +1105,8 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	/* The Connext uses non-standard BAR */

   This comment probably needs updating now to include your device.

>  	if (pdev->vendor == PCI_VENDOR_ID_STMICRO && pdev->device == 0xCC06)
>  		ahci_pci_bar = AHCI_PCI_BAR_STA2X11;
> +	else if (pdev->vendor == 0x1c44 && pdev->device == 0x8000)
> +		ahci_pci_bar = AHCI_PCI_BAR_ENMOTUS;
>  
>  	/* acquire resources */
>  	rc = pcim_enable_device(pdev);
> 

MBR, Sergei

