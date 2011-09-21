Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775Ab1IUFEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 01:04:51 -0400
Received: from rs35.luxsci.com ([66.216.127.90]:47426 "EHLO rs35.luxsci.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485Ab1IUFEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 01:04:48 -0400
X-Greylist: delayed 365 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Sep 2011 01:04:48 EDT
Message-ID: <4E796EE4.6070704@firmworks.com>
Date: Tue, 20 Sep 2011 18:58:12 -1000
From: Mitch Bradley <wmb@firmworks.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: David Miller <davem@davemloft.net>, dave.martin@linaro.org,
        linux@arm.linux.org.uk, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/3] GIC OF bindings
References: <1316550244-3655-1-git-send-email-robherring2@gmail.com> <20110920.224910.1996429830782124690.davem@davemloft.net> <CACxGe6t7Mdr+w+aGFPM2-FEAQaYHuG8Za9dybLgMo-5-whLyNQ@mail.gmail.com>
In-Reply-To: <CACxGe6t7Mdr+w+aGFPM2-FEAQaYHuG8Za9dybLgMo-5-whLyNQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/20/2011 6:14 PM, Grant Likely wrote:
> On Tue, Sep 20, 2011 at 8:49 PM, David Miller<davem@davemloft.net>  wrote:
>> From: Rob Herring<robherring2@gmail.com>
>> Date: Tue, 20 Sep 2011 15:24:01 -0500
>>
>>> Hopefully, this is the final or near final version of GIC binding support.
>>>
>>> Changes from the previous version:
>>> - SPIs and PPIs are numbered starting at 0. Now the gic has it's own irq
>>>    domain translate function instead of the simple domain one.
>>> - interrupt cell format has changed based on Grant's proposal.
>>> - Dropped "ARM: gic: allow irq_start to be 0". Instead, the first 16 irqs
>>>    are skipped and the domain irq_base adjusted accordingly.
>>> - Added a fix to of_irq_find_parent when the parent == child.
>>> - Renamed intc_desc.parent to intc_desc.interrupt_parent.
>>> - Implemented Grant's algorithm for walking the list of interrupt
>>>    controllers. Added a return value to interrupt init functions, so they
>>>    don't get added to the parent list on a init failure.
>>>
>>> The changes are significant enough that I did not include previous
>>> acked/reviewed/tested-by's.
>>
>> Just out of curiosity where does this "interrupt-parent" property
>> come from?
>>
>> On platforms I am familiar with, the parent path is walked to the root
>> and we stop at device nodes that have "interrupt-map" and
>> "interrupt-map-mask" properties.
>>
>> The map and mask are applied to the "reg" property of the device in
>> question to see which map entry matches, if a match is found the map
>> entry contains the translated interrupt.
>>
>> And this process continues over and over all the way to the root to get
>> the system interrupt that processor actually deals with.
>>
>> The mechanism shown here seems overly simplistic and not able to handle
>> the cases handled by existing OF property schemes in use for several
>> years on real systems.
>
> interrupt-parent has been implemented for years on powerpc.  I don't
> know if it was ever an Open Firmware thing, but it is in ePAPR [1],
> and ARM isn't doing anything novel in that regard.

interrupt-parent has been part of the interrupt mapping spec from the 
inception of same.

http://www.openfirmware.info/docs/rec.intmap.d09.pdf

>
> [1] section 2.4, page 30,
> https://www.power.org/resources/downloads/Power_ePAPR_APPROVED_v1.1.pdf
>
> It is true that is cannot handle all situations, but for those
> interrupt-map is still available.
>
> g.
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
>
>
