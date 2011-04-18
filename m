Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab1DRIdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 04:33:18 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52818 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab1DRIdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 04:33:13 -0400
Message-ID: <4DABF744.4010209@monstr.eu>
Date: Mon, 18 Apr 2011 10:33:08 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        john.williams@petalogix.com, linux-kernel@vger.kernel.org,
        hjk@hansjkoch.de, arnd@arndb.de
Subject: Re: [PATCH v2] uio/pdrv_genirq: Add OF support
References: <1302774106-32764-1-git-send-email-monstr@monstr.eu> <20110414165931.GA19228@pengutronix.de>
In-Reply-To: <20110414165931.GA19228@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

Wolfram Sang wrote:
> Hi Michal,
> 
> On Thu, Apr 14, 2011 at 11:41:46AM +0200, Michal Simek wrote:
>> Support OF support. "generic-uio" compatible property is used.
> 
> This description is not true anymore. Please also add a short paragrpah how it
> is intended to be used now.

ok.

> 
>> Signed-off-by: Michal Simek <monstr@monstr.eu>
> 
>> +		uioinfo->version = "dt";
> 
> Minor nit: "devicetree" is probably more descriptive.

no problem to change it

> 
>> +
>> +		/* Multiple IRQs are not supported */
>> +		if (pdev->num_resources > 1) {
>> +			struct resource *r = &pdev->resource[1];
> 
> Are you sure the irq-ressource is always [1]?  (Similar question for the
> if()-block above). Try platform_get_irq().

I wasn't aware about platform_get_irq. You are right.

What "if()-block above" are you talking about?
Above is kzalloc uioinfo allocation.
I am going to send v3 that's why please comment this there.

> 
>> +#ifdef CONFIG_OF
>> +/*
>> + * Empty match table for of_platform binding
> 
> While it probably doesn't make change to put every supported device in
> upstream, it still deosn't technically have to be empty. So, mabye drop this
> comment and add something like "/* empty for now */" to the table?

ok, done.

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
