Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab1G1SdX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 14:33:23 -0400
Received: from rere.qmqm.pl ([89.167.52.164]:54563 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452Ab1G1SdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 14:33:21 -0400
Date: Thu, 28 Jul 2011 20:33:19 +0200
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: Julia Lawall <julia@diku.dk>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] drivers/misc/cb710/core.c: Add missing pci_dev_put
Message-ID: <20110728183319.GC24120@rere.qmqm.pl>
References: <1311870407-22461-1-git-send-email-julia@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1311870407-22461-1-git-send-email-julia@diku.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 28, 2011 at 06:26:46PM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> Pci_get_slot calls pci_dev_get, so pci_dev_put is needed before leaving the
> function.
[...]
> --- a/drivers/misc/cb710/core.c
> +++ b/drivers/misc/cb710/core.c
> @@ -41,7 +41,7 @@ static int __devinit cb710_pci_configure(struct pci_dev *pdev)
>  
>  	pci_read_config_dword(pdev, 0x48, &val);
>  	if (val & 0x80000000)
> -		return 0;
> +		goto out;
>  
>  	if (!pdev0)
>  		return -ENODEV;

The good fix is to use pci_get_slot() before the !pdev0 condition above.
I'll send a patch shortly.

Best Regards,
Micha³ Miros³aw
