Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255Ab2KBP1n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 11:27:43 -0400
Received: from exprod5og115.obsmtp.com ([64.18.0.246]:47926 "EHLO
	exprod5og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753966Ab2KBP1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 11:27:41 -0400
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Nov 2012 11:27:40 EDT
Message-ID: <5093E539.6050801@ge.com>
Date: Fri, 02 Nov 2012 15:22:33 +0000
From: Martyn Welch <martyn.welch@ge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Wei Yongjun <weiyj.lk@gmail.com>
CC: manohar.vanga@gmail.com, gregkh@linuxfoundation.org,
        yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vme: vme_tsi148.c: use module_pci_driver to simplify
 the code
References: <CAPgLHd-H31dtsbyMmYmPnG7VnOTPMc23w7y5e6DN_wvpcqxBkQ@mail.gmail.com>
In-Reply-To: <CAPgLHd-H31dtsbyMmYmPnG7VnOTPMc23w7y5e6DN_wvpcqxBkQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Nov 2012 15:22:35.0657 (UTC) FILETIME=[E2EDEF90:01CDB90D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/10/2012 16:12, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Use the module_pci_driver() macro to make the code simpler
> by eliminating module_init and module_exit calls.
>
> dpatch engine is used to auto generate this patch.
> (https://github.com/weiyj/dpatch)
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Huh, learn something new every day :-)

Acked-by: Martyn Welch <martyn.welch@ge.com>

Thanks,

Martyn

> ---
>   drivers/vme/bridges/vme_tsi148.c | 15 +--------------
>   1 file changed, 1 insertion(+), 14 deletions(-)
>
> diff --git a/drivers/vme/bridges/vme_tsi148.c b/drivers/vme/bridges/vme_tsi148.c
> index 5fbd08f..9c1aa4d 100644
> --- a/drivers/vme/bridges/vme_tsi148.c
> +++ b/drivers/vme/bridges/vme_tsi148.c
> @@ -35,10 +35,8 @@
>   #include "../vme_bridge.h"
>   #include "vme_tsi148.h"
>
> -static int __init tsi148_init(void);
>   static int tsi148_probe(struct pci_dev *, const struct pci_device_id *);
>   static void tsi148_remove(struct pci_dev *);
> -static void __exit tsi148_exit(void);
>
>
>   /* Module parameter */
> @@ -2244,11 +2242,6 @@ static void tsi148_free_consistent(struct device *parent, size_t size,
>   	pci_free_consistent(pdev, size, vaddr, dma);
>   }
>
> -static int __init tsi148_init(void)
> -{
> -	return pci_register_driver(&tsi148_driver);
> -}
> -
>   /*
>    * Configure CR/CSR space
>    *
> @@ -2754,10 +2747,7 @@ static void tsi148_remove(struct pci_dev *pdev)
>   	kfree(tsi148_bridge);
>   }
>
> -static void __exit tsi148_exit(void)
> -{
> -	pci_unregister_driver(&tsi148_driver);
> -}
> +module_pci_driver(tsi148_driver);
>
>   MODULE_PARM_DESC(err_chk, "Check for VME errors on reads and writes");
>   module_param(err_chk, bool, 0);
> @@ -2767,6 +2757,3 @@ module_param(geoid, int, 0);
>
>   MODULE_DESCRIPTION("VME driver for the Tundra Tempe VME bridge");
>   MODULE_LICENSE("GPL");
> -
> -module_init(tsi148_init);
> -module_exit(tsi148_exit);
>


-- 
Martyn Welch (Lead Software Engineer)  | Registered in England and Wales
GE Intelligent Platforms               | (3828642) at 100 Barbirolli Square
T +44(0)1327322748                     | Manchester, M2 3AB
E martyn.welch@ge.com                  | VAT:GB 927559189

