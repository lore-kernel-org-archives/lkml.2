Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab2BPRwf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 12:52:35 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:43575 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab2BPRwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 12:52:34 -0500
Message-ID: <4F3D424C.2020306@ti.com>
Date: Thu, 16 Feb 2012 18:52:12 +0100
From: "Cousson, Benoit" <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH v5 08/27] irq_domain: Move irq_domain code from powerpc
 to kernel/irq
References: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca> <1329383368-12122-9-git-send-email-grant.likely@secretlab.ca> <4F3D3F21.3060905@ti.com>
In-Reply-To: <4F3D3F21.3060905@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, forget about it, I've just seen your email on that and pulled your 
latest update.

Regards,
Benoit

On 2/16/2012 6:38 PM, Cousson, Benoit wrote:
> Hi Grant,
>
> It looks like there is a small regression in that update, it cannot
> build due to a missing semi-colon.
>
> On 2/16/2012 10:09 AM, Grant Likely wrote:
>> +/**
>> + * irq_find_mapping() - Find a linux irq from an hw irq number.
>> + * @host: domain owning this hardware interrupt
>> + * @hwirq: hardware irq number in that host space
>> + *
>> + * This is a slow path, for use by generic code. It's expected that an
>> + * irq controller implementation directly calls the appropriate low
>> level
>> + * mapping function.
>> + */
>> +unsigned int irq_find_mapping(struct irq_domain *host,
>> + irq_hw_number_t hwirq)
>> +{
>> + unsigned int i;
>> + unsigned int hint = hwirq % irq_virq_count;
>> +
>> + /* Look for default host if nececssary */
>> + if (host == NULL)
>> + host = irq_default_host;
>> + if (host == NULL)
>> + return NO_IRQ;
>> +
>> + /* legacy -> bail early */
>> + if (host->revmap_type == IRQ_DOMAIN_MAP_LEGACY)
>> + return hwirq;
>> +
>> + /* Slow path does a linear search of the map */
>> + if (hint == 0)
>> + hint = 1;
>> + i = hint;
>> + do {
>> + struct irq_data *data = irq_get_irq_data(i);
>> + if (data&& (data->domain == host)&& (data->hwirq == hwirq))
>> + return i;
>> + i++;
>> + if (i>= irq_virq_count)
>> + i = 1
>
> The ";" is missing.
>
> Regards,
> Benoit

