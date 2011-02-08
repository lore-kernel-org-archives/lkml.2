Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965Ab1BHKEj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 05:04:39 -0500
Received: from sncsmrelay2.nai.com ([67.97.80.206]:32484 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab1BHKEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 05:04:38 -0500
Message-ID: <4D5114D6.7080806@snapgear.com>
Date: Tue, 8 Feb 2011 20:03:02 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Greg Ungerer <gerg@uclinux.org>
Subject: Re: [patch 07/10] m68knommu: Convert 5272 intc irq_chip to new functions
References: <20110206233845.480884215@linutronix.de> <20110206233904.777004540@linutronix.de> <4D50B773.2070507@snapgear.com> <alpine.LFD.2.00.1102081047020.31804@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1102081047020.31804@localhost6.localdomain6>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Feb 2011 10:03:50.0580 (UTC) FILETIME=[7C030740:01CBC777]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Thomas,

On 08/02/11 19:48, Thomas Gleixner wrote:
> On Tue, 8 Feb 2011, Greg Ungerer wrote:
>>>   static void intc_external_irq(unsigned int irq, struct irq_desc *desc)
>>>   {
>>> -	desc->chip->ack(irq);
>>> +	get_irq_desc_chip(i)->irq_ack(desc->irq_data);
>>                           ^^^         ^^^
>> should this be:
>>
>>          get_irq_desc_chip(desc)->irq_ack(&desc->irq_data)
>
> Yes.
>
>> I can't runtime test this right at the moment, but otherwise:
>>
>> Acked-by: Greg Ungerer<gerg@uclinux.org>
>
> Can you push that stuff linus wards for 39 or want me to do it ? It
> has no dependencies whatsoever.

I am happy to push this for 39.

Thanks
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
