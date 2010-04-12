Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750971Ab0DLEMn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 00:12:43 -0400
Received: from mga10.intel.com ([192.55.52.92]:11250 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750702Ab0DLEMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 00:12:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,187,1270450800"; 
   d="scan'208";a="557000018"
Subject: Re: [PATCH V2 ] ioatdma:  Release memory in error handling path
From: minskey <chaohong_guo@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: dan.j.williams@intel.com
In-Reply-To: <1271043661.4957.13.camel@minskey-desktop>
References: <1271043661.4957.13.camel@minskey-desktop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Apr 2010 12:00:54 +0800
Message-ID: <1271044854.4957.20.camel@minskey-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Very sorry, re-send it : correct for compiling error


    Release memory in error handling path

Signed-off-by: Minskey Guo <chaohong_guo@linux.intel.com>

---
 drivers/dma/ioat/pci.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/ioat/pci.c b/drivers/dma/ioat/pci.c
index a6e93ee..2a3dae9 100644
--- a/drivers/dma/ioat/pci.c
+++ b/drivers/dma/ioat/pci.c
@@ -153,10 +153,12 @@ static int __devinit ioat_pci_probe(struct pci_dev
*pdev, const struct pci_devic
        else if (device->version >= IOAT_VER_3_0)
                err = ioat3_dma_probe(device, ioat_dca_enabled);
        else
-               return -ENODEV;
+               err = -ENODEV;

        if (err) {
                dev_err(dev, "Intel(R) I/OAT DMA Engine init failed\n");
+               pci_set_drvdata(pdev, NULL);
+               devm_kfree(dev, device);
                return -ENODEV;
        }
--
1.6.3.3


-minskey


在 2010-04-12一的 11:41 +0800，minskey写道：
> Release memory in error handling path
> 
> Signed-off-by: Minskey Guo <chaohong_guo@linux.intel.com>
> 
> ---
>  drivers/dma/ioat/pci.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/dma/ioat/pci.c b/drivers/dma/ioat/pci.c
> index a6e93ee..2a3dae9 100644
> --- a/drivers/dma/ioat/pci.c
> +++ b/drivers/dma/ioat/pci.c
> @@ -153,10 +153,12 @@ static int __devinit ioat_pci_probe(struct pci_dev
> *pdev, const struct pci_devic
>         else if (device->version >= IOAT_VER_3_0)
>                 err = ioat3_dma_probe(device, ioat_dca_enabled);
>         else
> -               return -ENODEV;
> +               err = -ENODEV;
> 
>         if (err) {
>                 dev_err(dev, "Intel(R) I/OAT DMA Engine init failed\n");
> +               pci_set_drvdata(pdev, NULL);
> +               devm_kfree(dev, device)
>                 return -ENODEV;
>         }
> --
> 1.6.3.3
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


