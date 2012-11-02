Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276Ab2KBPdV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 11:33:21 -0400
Received: from exprod5og113.obsmtp.com ([64.18.0.26]:57832 "EHLO
	exprod5og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab2KBPdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 11:33:20 -0400
Message-ID: <5093E566.7030200@ge.com>
Date: Fri, 02 Nov 2012 15:23:18 +0000
From: Martyn Welch <martyn.welch@ge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Wei Yongjun <weiyj.lk@gmail.com>
CC: manohar.vanga@gmail.com, gregkh@linuxfoundation.org,
        yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vme: vme_ca91cx42.c: use module_pci_driver to simplify
 the code
References: <CAPgLHd__XiRNpPNqePy2Qa1_8-SMbyF54Ef-Cko5pR7+nPCxxw@mail.gmail.com>
In-Reply-To: <CAPgLHd__XiRNpPNqePy2Qa1_8-SMbyF54Ef-Cko5pR7+nPCxxw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Nov 2012 15:23:20.0091 (UTC) FILETIME=[FD6A06B0:01CDB90D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/10/2012 16:13, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Use the module_pci_driver() macro to make the code simpler
> by eliminating module_init and module_exit calls.
>
> dpatch engine is used to auto generate this patch.
> (https://github.com/weiyj/dpatch)
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Martyn Welch <martyn.welch@ge.com>

> ---
>   drivers/vme/bridges/vme_ca91cx42.c | 15 +--------------
>   1 file changed, 1 insertion(+), 14 deletions(-)
>
> diff --git a/drivers/vme/bridges/vme_ca91cx42.c b/drivers/vme/bridges/vme_ca91cx42.c
> index 1425d22c..64bfea3 100644
> --- a/drivers/vme/bridges/vme_ca91cx42.c
> +++ b/drivers/vme/bridges/vme_ca91cx42.c
> @@ -34,10 +34,8 @@
>   #include "../vme_bridge.h"
>   #include "vme_ca91cx42.h"
>   
> -static int __init ca91cx42_init(void);
>   static int ca91cx42_probe(struct pci_dev *, const struct pci_device_id *);
>   static void ca91cx42_remove(struct pci_dev *);
> -static void __exit ca91cx42_exit(void);
>   
>   /* Module parameters */
>   static int geoid;
> @@ -1523,11 +1521,6 @@ static void ca91cx42_free_consistent(struct device *parent, size_t size,
>   	pci_free_consistent(pdev, size, vaddr, dma);
>   }
>   
> -static int __init ca91cx42_init(void)
> -{
> -	return pci_register_driver(&ca91cx42_driver);
> -}
> -
>   /*
>    * Configure CR/CSR space
>    *
> @@ -1944,16 +1937,10 @@ static void ca91cx42_remove(struct pci_dev *pdev)
>   	kfree(ca91cx42_bridge);
>   }
>   
> -static void __exit ca91cx42_exit(void)
> -{
> -	pci_unregister_driver(&ca91cx42_driver);
> -}
> +module_pci_driver(ca91cx42_driver);
>   
>   MODULE_PARM_DESC(geoid, "Override geographical addressing");
>   module_param(geoid, int, 0);
>   
>   MODULE_DESCRIPTION("VME driver for the Tundra Universe II VME bridge");
>   MODULE_LICENSE("GPL");
> -
> -module_init(ca91cx42_init);
> -module_exit(ca91cx42_exit);
>


-- 
Martyn Welch (Lead Software Engineer)  | Registered in England and Wales
GE Intelligent Platforms               | (3828642) at 100 Barbirolli Square
T +44(0)1327322748                     | Manchester, M2 3AB
E martyn.welch@ge.com                  | VAT:GB 927559189

