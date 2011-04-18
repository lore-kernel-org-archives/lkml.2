Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab1DRIsH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 04:48:07 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62884 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab1DRIr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 04:47:59 -0400
Message-ID: <4DABFABB.7080208@monstr.eu>
Date: Mon, 18 Apr 2011 10:47:55 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: "Hans J. Koch" <hjk@hansjkoch.de>
CC: devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        john.williams@petalogix.com, linux-kernel@vger.kernel.org,
        w.sang@pengutronix.de, arnd@arndb.de
Subject: Re: [PATCH v2] uio/pdrv_genirq: Add OF support
References: <1302774106-32764-1-git-send-email-monstr@monstr.eu> <20110414230602.GC2780@local>
In-Reply-To: <20110414230602.GC2780@local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans J. Koch wrote:
> On Thu, Apr 14, 2011 at 11:41:46AM +0200, Michal Simek wrote:
>> Support OF support. "generic-uio" compatible property is used.
>>
>> Signed-off-by: Michal Simek <monstr@monstr.eu>
>>
>> ---
>> v2: Remove additional resource binding
>>     Setup correct version string
>>     Clear compatible string
>> ---
>>  drivers/uio/uio_pdrv_genirq.c |   45 +++++++++++++++++++++++++++++++++++++++++
>>  1 files changed, 45 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
>> index 7174d51..fd84a93 100644
>> --- a/drivers/uio/uio_pdrv_genirq.c
>> +++ b/drivers/uio/uio_pdrv_genirq.c
>> @@ -23,6 +23,10 @@
>>  #include <linux/pm_runtime.h>
>>  #include <linux/slab.h>
>>  
>> +#include <linux/of.h>
>> +#include <linux/of_platform.h>
>> +#include <linux/of_address.h>
>> +
>>  #define DRIVER_NAME "uio_pdrv_genirq"
>>  
>>  struct uio_pdrv_genirq_platdata {
>> @@ -97,6 +101,28 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
>>  	int ret = -EINVAL;
>>  	int i;
>>  
>> +	if (!uioinfo) {
>> +		/* alloc uioinfo for one device */
>> +		uioinfo = kzalloc(sizeof(*uioinfo), GFP_KERNEL);
>> +		if (!uioinfo) {
>> +			ret = -ENOMEM;
>> +			dev_err(&pdev->dev, "unable to kmalloc\n");
>> +			goto bad2;
>> +		}
>> +		uioinfo->name = pdev->dev.of_node->name;
>> +		uioinfo->version = "dt";
> 
> Can that be something more descriptive?

look at my previous post.

> 
>> +
>> +		/* Multiple IRQs are not supported */
> 
> But multiple mappings are, and also no mappings.

I have tested multiple mappings and it is no problem to use it.
No mapping is also fine.

> 
>> +		if (pdev->num_resources > 1) {
>> +			struct resource *r = &pdev->resource[1];
>> +			uioinfo->irq = r->start;
> 
> Why has the irq be resource[1] ?

look at my previous post.

Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
