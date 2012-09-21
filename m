Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab2IUPvL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 11:51:11 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46663 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932Ab2IUPvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 11:51:09 -0400
Message-ID: <505C8CE9.6040201@wwwdotorg.org>
Date: Fri, 21 Sep 2012 09:51:05 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: akpm@linux-foundation.org, a.zummo@towertech.it,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Subject: Re: [PATCH] rtc: tps65910: Use platform_get_irq to get RTC irq details
References: <1348225223-32156-1-git-send-email-vbyravarasu@nvidia.com>
In-Reply-To: <1348225223-32156-1-git-send-email-vbyravarasu@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2012 05:00 AM, Venu Byravarasu wrote:
> As RTC driver needs only irq number from platform data,
> using platform_get_irq(), instead of generic dev_get_platdata().

I assume this patch depends on "mfd: tps65910: Add alarm interrupt of
TPS65910 RTC to mfd device list" which you posted just before? If so,
the two patches should go through the same tree to avoid "git bisect"
issues.

Also, I thought you needed to fix the MFD driver to call
mfd_add_devices() only after all the IRQ stuff had been set up -
otherwise, when the RTC driver calls devm_request_threaded_irq(), the
parent IRQ domain that the IRQ points at won't exist, and the call will
fail.

Also, the MFD patch you sent to create add the IRQ resource into the RTC
device's resource list sets the IRQ number to TPS65910_IRQ_RTC_ALARM,
which is the offset within the IRQ domain, not the absolute Linux IRQ
number. Where does the base of the IRQ domain get added on such that
this is an actual IRQ numbmer not an offset?

> -	dev_dbg(&pdev->dev, "Enabling rtc-tps65910.\n");
> +	dev_dbg(&pdev->dev, "Enabling tps65910 rtc.\n");

Unrelated change.

> -	irq = pmic_plat_data->irq_base;
> +	irq  = platform_get_irq(pdev, 0);

There are two spaces there before the =.

> -		"rtc-tps65910", &pdev->dev);
> +		"tps65910-rtc", &pdev->dev);

Unrelated change.

> -		.name	= "rtc-tps65910",
> +		.name	= "tps65910-rtc",

Unrelated change.
