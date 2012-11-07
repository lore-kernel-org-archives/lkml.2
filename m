Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab2KGRLp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 12:11:45 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:44536 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab2KGRLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 12:11:44 -0500
Message-ID: <509A964D.2050205@wwwdotorg.org>
Date: Wed, 07 Nov 2012 10:11:41 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linus.walleij@linaro.org, grant.likely@secretlab.ca, swarren@nvidia.com,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 2/2] gpio: tegra: fix suspend/resume apis
References: <1352300492-24779-1-git-send-email-ldewangan@nvidia.com> <1352300492-24779-2-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1352300492-24779-2-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2012 08:01 AM, Laxman Dewangan wrote:
> Following are changes done to fix the suspend/resume
> functionality of tegra gpio driver:
> - Protect suspend/resume callbacks with CONFIG_PM_SLEEP
>   because CONFIG_PM doesn't actually enable any of the PM callbacks, it
>   only allows to enable CONFIG_PM_SLEEP and CONFIG_PM_RUNTIME.
>   This means if CONFIG_PM is used to protect system sleep callbacks
>   then it may end up unreferenced if only runtime PM is enabled.
> 
> - Fix the suspend/resume APIs declaration as per callback prototype.

Seems plausible, so this patch,
Acked-by: Stephen Warren <swarren@nvidia.com>

I wonder why the suspend/resume functions weren't actually hooked up
anywhere before. Oh well.

Just one very minor nit below:

> diff --git a/drivers/gpio/gpio-tegra.c b/drivers/gpio/gpio-tegra.c

> +#ifdef CONFIG_PM_SLEEP
> +static int  tegra_gpio_resume(struct device *dev)

There are two spaces after "int" there.
