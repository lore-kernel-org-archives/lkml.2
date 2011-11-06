Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182Ab1KFVpJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 16:45:09 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:50088 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab1KFVpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 16:45:07 -0500
X-Greylist: delayed 477 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Nov 2011 16:45:07 EST
In-Reply-To: <1320613517-3086-1-git-send-email-peterhuewe@gmx.de>
References: <1320613517-3086-1-git-send-email-peterhuewe@gmx.de>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <59D8A47D-7B28-48CA-82D3-BCB50619D683@iki.fi>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Arnaud Patard <apatard@mandriva.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: [PATCH] staging/xgifb: Convert pci_table entries to PCI_DEVICE (if PCI_ANY_ID is used)
Date: Sun, 6 Nov 2011 23:37:53 +0200
To: Peter Huewe <peterhuewe@gmx.de>
X-Mailer: Apple Mail (2.753.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 6.11.2011, at 23.05, Peter Huewe wrote:
> This patch converts pci_table entries to use the PCI_DEVICE macro,
> if .subvendor and .subdevice are set to PCI_ANY_ID,
> and thus improves readability.
>
> KernelVersion: Staging-20111106
> ---
>  drivers/staging/xgifb/XGI_main.h |   12 ++++--------
>  1 files changed, 4 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/staging/xgifb/XGI_main.h b/drivers/staging/ 
> xgifb/XGI_main.h
> index 71aebe3..0c3f421 100644
> --- a/drivers/staging/xgifb/XGI_main.h
> +++ b/drivers/staging/xgifb/XGI_main.h
> @@ -32,14 +32,10 @@
>  #endif
>
>  static DEFINE_PCI_DEVICE_TABLE(xgifb_pci_table) = {
> -	{PCI_VENDOR_ID_XG, PCI_DEVICE_ID_XG_20, PCI_ANY_ID, PCI_ANY_ID,
> -	 0, 0, 0},
> -	{PCI_VENDOR_ID_XG, PCI_DEVICE_ID_XG_27, PCI_ANY_ID, PCI_ANY_ID,
> -	 0, 0, 1},
> -	{PCI_VENDOR_ID_XG, PCI_DEVICE_ID_XG_40, PCI_ANY_ID, PCI_ANY_ID,
> -	 0, 0, 2},
> -	{PCI_VENDOR_ID_XG, PCI_DEVICE_ID_XG_42, PCI_ANY_ID, PCI_ANY_ID,
> -	 0, 0, 3},
> +	{PCI_DEVICE(PCI_VENDOR_ID_XG, PCI_DEVICE_ID_XG_20), 0, 0, 0},

I think the correct way would be

	{PCI_DEVICE(PCI_VENDOR_ID_XG, PCI_DEVICE_ID_XG_20), .driver_data = 0},

or

	{PCI_VDEVICE(PCI_VENDOR_ID_XG, PCI_DEVICE_ID_XG_20), 0},

But I don't see the driver_data even being used anywhere, so then you  
could
just simply say:

	{PCI_DEVICE(PCI_VENDOR_ID_XG, PCI_DEVICE_ID_XG_20)},

A.

