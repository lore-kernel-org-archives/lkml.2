Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab2CXNSW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 09:18:22 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47936 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873Ab2CXNSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 09:18:21 -0400
Message-ID: <4F6DC98D.9040800@gmail.com>
Date: Sat, 24 Mar 2012 08:18:05 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120310 Thunderbird/11.0
MIME-Version: 1.0
To: Thomas Abraham <thomas.abraham@linaro.org>
CC: devicetree-discuss@lists.ozlabs.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        patches@linaro.org
Subject: Re: [PATCH] of/irq: add empty irq_of_parse_and_map() for non-dt builds
References: <1332581257-15989-1-git-send-email-thomas.abraham@linaro.org> <4F6DC847.8000902@gmail.com>
In-Reply-To: <4F6DC847.8000902@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2012 08:12 AM, Rob Herring wrote:
> On 03/24/2012 04:27 AM, Thomas Abraham wrote:
>> Add a empty irq_of_parse_and_map() that returns 0 for non-dt builds and
>> avoid having #ifdef CONFIG_OF around all calls to irq_of_parse_and_map().
>>
>> Suggested-by: Grant Likely <grant.likely@secretlab.ca>
>> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
>> ---
> 
> Acked-by: Rob Herring <rob.herring@calxeda.com>
> 
> Go ahead and merge with the rest of your series.
> 

Screwed up the lkml address, so just adding it back...

Rob

> Rob
> 
>>  include/linux/of_irq.h |    6 ++++++
>>  1 files changed, 6 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/of_irq.h b/include/linux/of_irq.h
>> index d229ad3..5614355 100644
>> --- a/include/linux/of_irq.h
>> +++ b/include/linux/of_irq.h
>> @@ -76,5 +76,11 @@ extern struct device_node *of_irq_find_parent(struct device_node *child);
>>  extern void of_irq_init(const struct of_device_id *matches);
>>  
>>  #endif /* CONFIG_OF_IRQ */
>> +#else /* CONFIG_OF */
>> +static inline unsigned int irq_of_parse_and_map(struct device_node *dev,
>> +						int index)
>> +{
>> +	return 0;
>> +}
>>  #endif /* CONFIG_OF */
>>  #endif /* __OF_IRQ_H */
> 

