Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab2LKPmG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 10:42:06 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:51875 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083Ab2LKPmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 10:42:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC v1 01/16] lib: devres: don't enclose pcim_*() functions in CONFIG_HAS_IOPORT
Date: Tue, 11 Dec 2012 10:43:49 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        "Eran Ben-Avi" <benavi@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Shadi Ammouri <shadi@marvell.com>,
        Yinghai Lu <yinghai@kernel.org>
References: <1354917879-32073-1-git-send-email-thomas.petazzoni@free-electrons.com> <1354917879-32073-2-git-send-email-thomas.petazzoni@free-electrons.com>
In-Reply-To: <1354917879-32073-2-git-send-email-thomas.petazzoni@free-electrons.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201212111043.50627.arnd@arndb.de>
X-Provags-ID: V02:K0:p3m27j/RX/BP0nZKOxGu2KLegAtqLM6d2fQDcQjJI+N
 Ohjr1qmfv/sa81Jnzwx+Pwau/EEE2noTwuDJAEhlJjrdPR4hMQ
 X12I9KSb8KrHEVEGzu+sDygAQZ3wv9w0OldefA0l9rjFO8bxTX
 2z54eOJt0FUqbi/qiM0TqQiIl/b66bRQbu2s1MZ6pMdNFYG4da
 Z8qgzNTaKCNSzB9m4ZwciMEBeBg6SCyb0DPAQO3JZYQI/nDLm2
 cUvSJfeGJyXhRhqYtnCmmUmz6dd0DatnEir2dljpAjvjD0JmE2
 AmxUETHs6gmS957j+H+A+P5R0MBmjDhI3M1KuN5kDW0lvzQ4vH
 cr6yXhZiKCRZmDkn9F5g=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 December 2012, Thomas Petazzoni wrote:
> The pcim_*() functions are used by the libata-sff subsystem, and this
> subsystem is used for many SATA drivers on ARM platforms that do not
> necessarily have I/O ports.

I think this one is wrong as the CONFIG_HAS_IOPORT does not refer to the
presence of PIO ports but to whether or not they provide an ioport_map
function. If there is no ioport_map(), devm_pci_iomap will fail to link
as far as I can tell.

	Arnd

> Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: linux-kernel@vger.kernel.org
> ---
>  lib/devres.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/devres.c b/lib/devres.c
> index 80b9c76..5639c3e 100644
> --- a/lib/devres.c
> +++ b/lib/devres.c
> @@ -195,6 +195,7 @@ void devm_ioport_unmap(struct device *dev, void __iomem *addr)
>  			       devm_ioport_map_match, (void *)addr));
>  }
>  EXPORT_SYMBOL(devm_ioport_unmap);
> +#endif /* CONFIG_HAS_IOPORT */
>  
>  #ifdef CONFIG_PCI
>  /*
> @@ -400,4 +401,3 @@ void pcim_iounmap_regions(struct pci_dev *pdev, int mask)
>  }
>  EXPORT_SYMBOL(pcim_iounmap_regions);
>  #endif /* CONFIG_PCI */
> -#endif /* CONFIG_HAS_IOPORT */


