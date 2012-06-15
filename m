Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab2FOMtv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 08:49:51 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34896 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756770Ab2FOMtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 08:49:50 -0400
Message-ID: <4FDB2F6A.8080300@linaro.org>
Date: Fri, 15 Jun 2012 13:49:46 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, linus.walleij@stericsson.com, arnd@arndb.de,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 08/14] mfd: Add IRQ domain support for the AB8500
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org> <1339428307-3850-9-git-send-email-lee.jones@linaro.org> <20120614183231.GA30185@sirena.org.uk>
In-Reply-To: <20120614183231.GA30185@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/06/12 19:32, Mark Brown wrote:
> On Mon, Jun 11, 2012 at 04:25:01PM +0100, Lee Jones wrote:
>
>> +	if (np) {
>> +		ab8500->domain = irq_domain_add_linear(
>> +			np, num_irqs,&ab8500_irq_ops, ab8500);
>> +	}
>> +	else {
>> +		ab8500->domain = irq_domain_add_legacy(
>> +			NULL, num_irqs, ab8500->irq_base,
>> +			0,&ab8500_irq_ops, ab8500);
>> +	}
>
> This is odd, why are you forcing non-DT systems to use a legacy mapping?
> The more usual approach is to use a legacy mapping if and only if a base
> for the legacy range has been provided, otherwise the system will
> needlessly fail to initialise the device...

Makes sense. I'll re-submit.

>> +	if (!(ab8500->irq_base || np)) {
>> +		dev_info(&pdev->dev, "couldn't find irq-base and not doing DT boot\n");
>
> ...like this.  See regmap_irq for an example.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
