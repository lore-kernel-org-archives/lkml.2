Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934578Ab1KJNhh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 08:37:37 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:65156 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab1KJNhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 08:37:35 -0500
Message-ID: <4EBBD39C.9000400@gmail.com>
Date: Thu, 10 Nov 2011 07:37:32 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Jamie Iles <jamie@jamieiles.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] irq: fix possible null-pointer deref irq_domain_to_irq
References: <1320922383-15312-1-git-send-email-jamie@jamieiles.com> <20111110111446.GB16018@totoro>
In-Reply-To: <20111110111446.GB16018@totoro>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2011 05:14 AM, Jamie Iles wrote:
> On Thu, Nov 10, 2011 at 10:53:03AM +0000, Jamie Iles wrote:
>> It is optional for an irqdomain to have a to_irq() method, and for
>> simple domains they often don't require any operations at all - just
>> hwirq to Linux irq translation.  Check we have valid ops before
>> dereferencing them.
>>
>> Patch originally by Rob Herring.
>>
>> Suggested-by: Rob Herring <robherring2@gmail.com>
> 
> Naturally git send-email doesn't know how to convert this into a CC, so 
> Rob is now CC'd!
> 
> Jamie
> 
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Grant Likely <grant.likely@secretlab.ca>
>> Signed-off-by: Jamie Iles <jamie@jamieiles.com>
>> ---
>>
>> Rob, I can't see that you've already posted this but I didn't want to
>> hold Marc's GIC patches up.

Thanks. I didn't get around to it yesterday.

Acked-by: Rob Herring <rob.herring@calxeda.com>

Rob

>>
>>  include/linux/irqdomain.h |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
>> index 99834e58..78a1e66 100644
>> --- a/include/linux/irqdomain.h
>> +++ b/include/linux/irqdomain.h
>> @@ -74,7 +74,7 @@ struct irq_domain {
>>  static inline unsigned int irq_domain_to_irq(struct irq_domain *d,
>>  					     unsigned long hwirq)
>>  {
>> -	if (d->ops->to_irq)
>> +	if (d->ops && d->ops->to_irq)
>>  		return d->ops->to_irq(d, hwirq);
>>  	if (WARN_ON(hwirq < d->hwirq_base))
>>  		return 0;
>> -- 
>> 1.7.4.1
>>

