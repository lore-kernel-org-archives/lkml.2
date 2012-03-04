Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351Ab2CDF2W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 00:28:22 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45779 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab2CDF2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 00:28:21 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of shawn.guo@linaro.org designates 10.50.202.38 as permitted sender) smtp.mail=shawn.guo@linaro.org
Date: Sun, 4 Mar 2012 13:42:39 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Venu Byravarasu <vbyravarasu@nvidia.com>,
        Peter Korsgaard <jacmet@sunsite.dk>
Subject: Re: [PATCH v7 1/2] mfd: Add anatop mfd driver
Message-ID: <20120304054237.GB10743@S2101-09.ap.freescale.net>
References: <1330671641-6439-1-git-send-email-paul.liu@linaro.org>
 <1330796352-6884-1-git-send-email-paul.liu@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330796352-6884-1-git-send-email-paul.liu@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 04, 2012 at 01:39:12AM +0800, Ying-Chun Liu (PaulLiu) wrote:
...
> +static int of_anatop_probe(struct platform_device *pdev)

__devinit

> +{
> +	struct device *dev = &pdev->dev;
> +	struct device_node *np = dev->of_node;
> +	void *ioreg;
> +	struct anatop *drvdata;
> +
> +	ioreg = of_iomap(np, 0);
> +	if (!ioreg)
> +		return -EINVAL;
> +	drvdata = devm_kzalloc(dev, sizeof(struct anatop), GFP_KERNEL);
> +	if (!drvdata)
> +		return -EINVAL;
> +	drvdata->ioreg = ioreg;
> +	spin_lock_init(&drvdata->reglock);
> +	platform_set_drvdata(pdev, drvdata);
> +	of_platform_bus_probe(np, of_anatop_subdevice_match, dev);
> +
> +	return 0;
> +}
> +
> +static int of_anatop_remove(struct platform_device *pdev)

__devexit

> +{
> +	struct anatop *drvdata;
> +	drvdata = platform_get_drvdata(pdev);
> +	iounmap(drvdata->ioreg);
> +	return 0;
> +}
> +

-- 
Regards,
Shawn
