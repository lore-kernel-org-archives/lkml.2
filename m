Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861Ab2KHEbV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 23:31:21 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12582 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205Ab2KHEbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 23:31:18 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 07 Nov 2012 20:18:00 -0800
Message-ID: <509B350E.5050105@nvidia.com>
Date: Thu, 8 Nov 2012 09:59:02 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 1/2] gpio: tegra: create irq mapping in gpio_to_irq
References: <1352300492-24779-1-git-send-email-ldewangan@nvidia.com> <509A9579.5090002@wwwdotorg.org>
In-Reply-To: <509A9579.5090002@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 November 2012 10:38 PM, Stephen Warren wrote:
> On 11/07/2012 08:01 AM, Laxman Dewangan wrote:
>> The gpio interrupts get mapped linearly and hence the mapping
>> of irq need to be created by irq_create_mapping().
>>
>> The function gpio_to_irq() returns the irq by irq_find_mapping()
>> and so returns 0 as there is no mapping created. Fix the function
>> to create mapping when gpio_to_irq() get called.
> I'm not convinced this should be needed. tegra_gpio_probe() contains:


Oh, yes, I did not observe this code in my review. So this change is not 
resolving any issue.


I think we should move the mapping to gpio_to_irq() rather than doing 
this in probe.

