Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab1LJKlr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 05:41:47 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46164 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532Ab1LJKlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 05:41:46 -0500
Message-ID: <4EE33766.6060704@monstr.eu>
Date: Sat, 10 Dec 2011 11:41:42 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: grant.likely@secretlab.ca, devicetree-discuss@lists.ozlabs.org,
        anton.vorontsov@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] microblaze: Introduce IRQ_SW_OFFSET to help with
 sw IRQ
References: <1323431121-12780-1-git-send-email-monstr@monstr.eu> <1323431121-12780-2-git-send-email-monstr@monstr.eu> <1323431121-12780-3-git-send-email-monstr@monstr.eu> <1323431121-12780-4-git-send-email-monstr@monstr.eu> <1323431121-12780-5-git-send-email-monstr@monstr.eu> <4EE21753.8050501@gmail.com>
In-Reply-To: <4EE21753.8050501@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Herring wrote:
> On 12/09/2011 05:45 AM, Michal Simek wrote:
>> If you setup IRQ_OFFSET > nr_irq you completely separate hardware
>> and software IRQs which help you with debugging.
>>
>> For example:
>> IRQ_SW_OFFSET = 32
>>
>>         DTS   HW(line)   LINUX
>> timer - 2     3          35
>> sysace  4     5          37
>> serial  5     6          38
>>
>> HW line is setup DTS + NO_IRQ_OFFSET to ensure that NO_IRQ is always 0.
>>
> 
> This is really confusing. DTS is the HW numbering. The last 2 columns
> are both Linux IRQ numbering. Just create a single define for an offset.
> Then I would combine this into the previous patch.
> 

DTS generator, which we used for DTS generator for more than 2 years,
generates for the first IRQ in the system this property "interrupts = < 0 2 >;"
Which is HW line 1 and linux irq_data->hwirq 0 (because of shift) and irq_data->irq = 1
for SW_OFFSET=0.

Anyway no problem to keep just NO_IRQ_OFFSET value.

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
