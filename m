Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996Ab2GPGjg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 02:39:36 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:8650 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab2GPGje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 02:39:34 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-5e-5003b72504f7
From: Jingoo Han <jg1.han@samsung.com>
To: "'Vivek Gautam'" <gautam.vivek@samsung.com>, stern@rowland.harvard.edu,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: l.majewski@samsung.com, a.kesavan@samsung.com, prashanth.g@samsung.com,
        kmpark@infradead.org, joshi@samsung.com, olofj@google.com,
        jy0922.shim@samsung.com, thomas.abraham@linaro.org,
        sshtylyov@mvista.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <1342418138-6192-1-git-send-email-gautam.vivek@samsung.com>
 <1342418138-6192-3-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1342418138-6192-3-git-send-email-gautam.vivek@samsung.com>
Subject: Re: [PATCH 2/3 v3] USB: ehci-s5p: Add support for device tree
Date: Mon, 16 Jul 2012 15:39:32 +0900
Message-id: <002801cd631d$c23d4890$46b7d9b0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1jFZ8zLeZMOFr7THiSGSTDi6fRngACAFdg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsVy+t9jQV3V7cwBBsemCVlc3jWHzWLRslZm
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDI2LTvFVPBKqKKj6R1LA+NU/i5GTg4JAROJr70PmSBs
	MYkL99azdTFycQgJTGeU+LVkPpTzi1Hix5np7CBVbAJqEl++HGYHSYgIrGKUWPLzMSuIwyzw
	k1HiYd8KFoiWVkaJVZ/us4G0cAp4SNyfdhnMFhZwk/j+YzZQEQcHi4CqxIZj1iBhXgFbiQNv
	elghbEGJH5PvsYDYzAJaEut3HmeCsOUlNq95ywzSKiGgLvHory5IWETASKL97GZmiBIRiX0v
	3jFOYBSahWTSLCSTZiGZNAtJywJGllWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwWH9TGoH
	48oGi0OMAhyMSjy8FhuYA4RYE8uKK3MPMUpwMCuJ8HZ2AoV4UxIrq1KL8uOLSnNSiw8xSnOw
	KInzGnt/9RcSSE8sSc1OTS1ILYLJMnFwSjUwtgcfVbxzvZBjypcHYdfZckS7ezd/Wqc6+cxp
	n28ce5i9DEpvFFxY3VibGb79r+lTDw0xMeE821LX4/9ttZsObK8KOazu/e+d/EZfwYnGuVzV
	uVfPPuLd7btqSS7ftjV77s1v+FlW0Jx493prAFdt7uoXh5T1v/j9bGURFgqqeWi1fLtHdm2c
	EktxRqKhFnNRcSIA9Cn7jmcCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 16, 2012 2:56 PM, Vivek Gautam wrote:
> 
> This patch adds support to parse probe data for
> ehci driver for exynos using device tree
> 
> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
> Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>

Acked-by: Jingoo Han <jg1.han@samsung.com>

> 
> diff --git a/drivers/usb/host/ehci-s5p.c b/drivers/usb/host/ehci-s5p.c
> index 13c179f..37d84cf 100644
> --- a/drivers/usb/host/ehci-s5p.c
> +++ b/drivers/usb/host/ehci-s5p.c
> @@ -13,6 +13,7 @@
>   */
> 
>  #include <linux/clk.h>
> +#include <linux/of.h>
>  #include <linux/platform_device.h>
>  #include <plat/ehci.h>
>  #include <plat/usb-phy.h>
> @@ -63,6 +64,8 @@ static const struct hc_driver s5p_ehci_hc_driver = {
>  	.clear_tt_buffer_complete	= ehci_clear_tt_buffer_complete,
>  };
> 
> +static u64 ehci_s5p_dma_mask = DMA_BIT_MASK(32);
> +
>  static int __devinit s5p_ehci_probe(struct platform_device *pdev)
>  {
>  	struct s5p_ehci_platdata *pdata;
> @@ -79,6 +82,16 @@ static int __devinit s5p_ehci_probe(struct platform_device *pdev)
>  		return -EINVAL;
>  	}
> 
> +	/*
> +	 * Right now device-tree probed devices don't get dma_mask set.
> +	 * Since shared usb code relies on it, set it here for now.
> +	 * Once we move to full device tree support this will vanish off.
> +	 */
> +	if (!pdev->dev.dma_mask)
> +		pdev->dev.dma_mask = &ehci_s5p_dma_mask;
> +	if (!pdev->dev.coherent_dma_mask)
> +		pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
> +
>  	s5p_ehci = devm_kzalloc(&pdev->dev, sizeof(struct s5p_ehci_hcd),
>  				GFP_KERNEL);
>  	if (!s5p_ehci)
> @@ -233,6 +246,14 @@ static const struct dev_pm_ops s5p_ehci_pm_ops = {
>  	.resume		= s5p_ehci_resume,
>  };
> 
> +#ifdef CONFIG_OF
> +static const struct of_device_id exynos_ehci_match[] = {
> +	{ .compatible = "samsung,exynos-ehci" },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, exynos_ehci_match);
> +#endif
> +
>  static struct platform_driver s5p_ehci_driver = {
>  	.probe		= s5p_ehci_probe,
>  	.remove		= __devexit_p(s5p_ehci_remove),
> @@ -241,6 +262,7 @@ static struct platform_driver s5p_ehci_driver = {
>  		.name	= "s5p-ehci",
>  		.owner	= THIS_MODULE,
>  		.pm	= &s5p_ehci_pm_ops,
> +		.of_match_table = of_match_ptr(exynos_ehci_match),
>  	}
>  };
> 
> --
> 1.7.0.4

