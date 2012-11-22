Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab2KVScM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:32:12 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59790 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870Ab2KVScE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:32:04 -0500
MIME-Version: 1.0
In-Reply-To: <1353373552-16039-5-git-send-email-omar.luna@linaro.org>
References: <1353373552-16039-1-git-send-email-omar.luna@linaro.org>
	<1353373552-16039-5-git-send-email-omar.luna@linaro.org>
Date: Thu, 22 Nov 2012 03:47:31 +0100
Message-ID: <CAMP44s0h+6XTaJv8q-MJe4vmDiBzNG2cjTugSn7nFyAsZPk+Ag@mail.gmail.com>
Subject: Re: [PATCH v5 4/5] iommu/omap: adapt to runtime pm
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Omar Ramirez Luna <omar.luna@linaro.org>
Cc: Tony Lindgren <tony@atomide.com>, Joerg Roedel <joro@8bytes.org>,
        Russell King <linux@arm.linux.org.uk>,
        Ohad Ben-Cohen <ohad@wizery.com>, Ido Yariv <ido@wizery.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Paul Walmsley <paul@pwsan.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, Kevin Hilman <khilman@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 2:05 AM, Omar Ramirez Luna <omar.luna@linaro.org> wrote:

> @@ -1022,7 +1019,8 @@ static int __devexit omap_iommu_remove(struct platform_device *pdev)
>         release_mem_region(res->start, resource_size(res));
>         iounmap(obj->regbase);
>
> -       clk_put(obj->clk);
> +       pm_runtime_disable(obj->dev);
> +
>         dev_info(&pdev->dev, "%s removed\n", obj->name);
>         kfree(obj);
>         return 0;

I still believe this is not needed. The device framework does that
when removing the device, and does it more properly, with
__pm_runtime_disable(dev, false).

Cheers.

-- 
Felipe Contreras
