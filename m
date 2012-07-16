Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab2GPNtH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 09:49:07 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:50294 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab2GPNtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 09:49:04 -0400
MIME-Version: 1.0
In-Reply-To: <1342189698-20393-2-git-send-email-vinholikatti@gmail.com>
References: <1342189698-20393-1-git-send-email-vinholikatti@gmail.com>
	<1342189698-20393-2-git-send-email-vinholikatti@gmail.com>
Date: Mon, 16 Jul 2012 22:49:02 +0900
Message-ID: <CAKYAXd9cPuN-HfifDmz4M==QfjEW7CX6BF=rumSBSwRtO38_PQ@mail.gmail.com>
Subject: Re: [PATCH V2 3/4] [SCSI] ufs: Add Platform glue driver for ufshcd
From: Namjae Jeon <linkinjeon@gmail.com>
To: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linux-samsung-soc@vger.kernel.org, santoshsy@gmail.com,
        arnd@linaro.org, girish.shivananjappa@linaro.org,
        saugata.das@linaro.org, vishak.g@samsung.com, venkat@linaro.org,
        k.rajesh@samsung.com, dsaxena@linaro.org, ilho215.lee@samsung.com,
        nala.la@samsung.com, sreekumar.c@samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinayak.
> + * ufshcd_pltfrm_remove - remove platform driver routine
> + * @pdev: pointer to platform device handle
> + *
> + * Returns 0 on success, non-zero value on failure
> + */
> +static int __devexit ufshcd_pltfrm_remove(struct platform_device *pdev)
> +{
> +	struct resource *mem_res;
> +	struct resource *irq_res;
> +	resource_size_t mem_size;
> +	struct ufs_hba *hba =  platform_get_drvdata(pdev);
> +
> +	ufshcd_remove(hba);
> +	irq_res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> +	if (!irq_res)
> +		dev_err(&pdev->dev, "ufshcd: IRQ resource not available\n");
> +	free_irq(irq_res->start, hba);
Is there no possibility of null pointer dereferencing error ?(irq_res->start)
I think that free_irq should be not called if irq_res is NULL.
> +	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
Looks mem_res is also same with upper case.
Thanks.
> +	mem_size = resource_size(mem_res);
> +	release_mem_region(mem_res->start, mem_size);
> +	platform_set_drvdata(pdev, NULL);
> +	return 0;
> +}
> +
