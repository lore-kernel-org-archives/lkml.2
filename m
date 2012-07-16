Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938Ab2GPGiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 02:38:20 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:60619 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab2GPGiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 02:38:16 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-42-5003b6d6de04
From: Jingoo Han <jg1.han@samsung.com>
To: "'Vivek Gautam'" <gautam.vivek@samsung.com>, stern@rowland.harvard.edu,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: l.majewski@samsung.com, a.kesavan@samsung.com, prashanth.g@samsung.com,
        kmpark@infradead.org, joshi@samsung.com, olofj@google.com,
        jy0922.shim@samsung.com, thomas.abraham@linaro.org,
        sshtylyov@mvista.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <1342418138-6192-1-git-send-email-gautam.vivek@samsung.com>
 <1342418138-6192-2-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1342418138-6192-2-git-send-email-gautam.vivek@samsung.com>
Subject: Re: [PATCH 1/3 v3] USB: ohci-exynos: Add support for device tree
Date: Mon, 16 Jul 2012 15:38:13 +0900
Message-id: <002701cd631d$9372fb40$ba58f1c0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1jFZ4BsZ5amfMmTJmxDJ+V8KaZ9wAB6zDw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t9jQd1r25gDDH68UbG4vGsOm8WiZa3M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGVsXHGJuWCOcMX5CVPYGxiP8XcxcnBICJhIzJ6n2cXI
	CWSKSVy4t56ti5GLQ0hgOqPEpxt/WCCcX4wSHxYcYgWpYhNQk/jy5TA7SEJEYBWjxJKfj1lB
	HGaBn4wSD/tWQLW0Mkos+PKaGaSFU8BDYvryWWwgtrCAp8S6jb9ZQGwWAVWJZVe+s4HcwStg
	K7F3VRJImFdAUOLH5HtgJcwCWhLrdx5ngrDlJTavecsMcba6xKO/uiBhEQEjiTufQQ4CKRGR
	2PfiHeMERqFZSCbNQjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHNTP
	pHYwrmywOMQowMGoxMNrsYE5QIg1say4MvcQowQHs5IIb2cnUIg3JbGyKrUoP76oNCe1+BCj
	NAeLkjivsfdXfyGB9MSS1OzU1ILUIpgsEwenVAOjYIHb+ctRHGK9Sr+19n1il00R8TF+YS5W
	d7gu7c9vtgvMxZbnDpzZcHC58QPXyuRZr6WfB9R3Tl7LZXDweMhZJm15adt1q41vBTbwyQVf
	U5xWN2Xq3AS5QBUzDY+rnfWiwcKndrm97pt69M/PLyy35X6H+uYe67lj/m26y7XqRZ8ezzh3
	26lOiaU4I9FQi7moOBEAcDsanGYCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 16, 2012 2:56 PM, Vivek Gautam wrote:
> 
> This patch adds support to parse probe data for
> ohci driver for exynos using device tree.
> 
> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
> Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>

Acked-by: Jingoo Han <jg1.han@samsung.com>

> 
> diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-exynos.c
> index 8bcbdb5..fc3091b 100644
> --- a/drivers/usb/host/ohci-exynos.c
> +++ b/drivers/usb/host/ohci-exynos.c
> @@ -12,6 +12,7 @@
>   */
> 
>  #include <linux/clk.h>
> +#include <linux/of.h>
>  #include <linux/platform_device.h>
>  #include <mach/ohci.h>
>  #include <plat/usb-phy.h>
> @@ -71,6 +72,8 @@ static const struct hc_driver exynos_ohci_hc_driver = {
>  	.start_port_reset	= ohci_start_port_reset,
>  };
> 
> +static u64 ohci_exynos_dma_mask = DMA_BIT_MASK(32);
> +
>  static int __devinit exynos_ohci_probe(struct platform_device *pdev)
>  {
>  	struct exynos4_ohci_platdata *pdata;
> @@ -87,6 +90,16 @@ static int __devinit exynos_ohci_probe(struct platform_device *pdev)
>  		return -EINVAL;
>  	}
> 
> +	/*
> +	 * Right now device-tree probed devices don't get dma_mask set.
> +	 * Since shared usb code relies on it, set it here for now.
> +	 * Once we move to full device tree support this will vanish off.
> +	 */
> +	if (!pdev->dev.dma_mask)
> +		pdev->dev.dma_mask = &ohci_exynos_dma_mask;
> +	if (!pdev->dev.coherent_dma_mask)
> +		pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
> +
>  	exynos_ohci = devm_kzalloc(&pdev->dev, sizeof(struct exynos_ohci_hcd),
>  					GFP_KERNEL);
>  	if (!exynos_ohci)
> @@ -256,6 +269,14 @@ static const struct dev_pm_ops exynos_ohci_pm_ops = {
>  	.resume		= exynos_ohci_resume,
>  };
> 
> +#ifdef CONFIG_OF
> +static const struct of_device_id exynos_ohci_match[] = {
> +	{ .compatible = "samsung,exynos-ohci" },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, exynos_ohci_match);
> +#endif
> +
>  static struct platform_driver exynos_ohci_driver = {
>  	.probe		= exynos_ohci_probe,
>  	.remove		= __devexit_p(exynos_ohci_remove),
> @@ -264,6 +285,7 @@ static struct platform_driver exynos_ohci_driver = {
>  		.name	= "exynos-ohci",
>  		.owner	= THIS_MODULE,
>  		.pm	= &exynos_ohci_pm_ops,
> +		.of_match_table	= of_match_ptr(exynos_ohci_match),
>  	}
>  };
> 
> --
> 1.7.0.4

