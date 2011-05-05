Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751339Ab1EEF0u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 01:26:50 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63823 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab1EEF0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 01:26:49 -0400
Message-ID: <4DC23513.2090007@monstr.eu>
Date: Thu, 05 May 2011 07:26:43 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: "Hans J. Koch" <hjk@hansjkoch.de>
CC: Wolfram Sang <w.sang@pengutronix.de>, devicetree-discuss@lists.ozlabs.org,
        grant.likely@secretlab.ca, john.williams@petalogix.com,
        linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH v4] uio/pdrv_genirq: Add OF support
References: <1304319115-32745-1-git-send-email-monstr@monstr.eu> <20110503203412.GA2119@pengutronix.de> <20110503221440.GB2737@local> <4DC152F3.2050500@monstr.eu> <20110504194730.GA2820@local>
In-Reply-To: <20110504194730.GA2820@local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans J. Koch wrote:
> On Wed, May 04, 2011 at 03:21:55PM +0200, Michal Simek wrote:
>> Hans J. Koch wrote:
>>> On Tue, May 03, 2011 at 10:34:12PM +0200, Wolfram Sang wrote:
>>>> On Mon, May 02, 2011 at 08:51:55AM +0200, Michal Simek wrote:
>>>>> Adding OF binding to genirq.
>>>>> Version string is setup to the "devicetree".
>>>>>
>>>>> Compatible string is not setup for now but you can add your
>>>>> custom compatible string to uio_of_genirq_match structure.
>>>>>
>>>>> For example with "vendor,device" compatible string:
>>>>> static const struct of_device_id __devinitconst uio_of_genirq_match[] = {
>>>>> 	{ .compatible = "vendor,device", },
>>>>> 	{ /* empty for now */ },
>>>>> };
>>>>>
>>>>> Signed-off-by: Michal Simek <monstr@monstr.eu>
>>>> [...]
>>>>
>>>>> +		/* alloc uioinfo for one device */
>>>>> +		uioinfo = kzalloc(sizeof(*uioinfo), GFP_KERNEL);
>>>> kfree in remove?
>>> Oh yes. Missed that one. It should probably look like the "bad0" case in probe().
>> Yes, freeing uioinfo in uio_pdrv_genirq_remove make sense for CONFIG_OF.
>>
>> Please correct me if I am wrong dev.of_node is not NULL for OF. I
>> think yes that's why I would prefer to use this construct instead of
>> #ifdef CONFIG_OF.
>>
>> 	if (pdev->dev.of_node)
>> 		kfree(pdev->dev.platform_data);
> 
> Huh? You didn't allocate platform_data, so you shouldn't free it.
> It's uioinfo you allocated.

grrr. I am stupid!

	/* kfree uioinfo for CONFIG_OF */
	if (pdev->dev.of_node)
		kfree(priv->uioinfo);


Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
