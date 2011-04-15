Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab1DOWRg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 18:17:36 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:59966 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757159Ab1DOWRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 18:17:35 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6317"; a="86120192"
Message-ID: <4DA8C3FC.5010102@codeaurora.org>
Date: Fri, 15 Apr 2011 15:17:32 -0700
From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: David Daney <ddaney@caviumnetworks.com>
CC: tglx@linutronix.de, mathieu.desnoyers@efficios.com,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org, dwalker@fifo99.com,
        linux-arm-msm-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [RFC PATCH] genirq: implement read_irq_line for interrupt lines
References: <1302892952-7090-1-git-send-email-adharmap@codeaurora.org> <4DA899E3.30409@caviumnetworks.com>
In-Reply-To: <4DA899E3.30409@caviumnetworks.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Daney wrote:
> On 04/15/2011 11:42 AM, Abhijeet Dharmapurikar wrote:
> [...]
>>
>> +/**
>> + *    irq_read_line - read the value on an irq line
>> + *    @irq: Interrupt number representing a hardware line
>> + *
>> + *    This function may be called from IRQ context only when
>> + *    desc->chip->bus_lock and desc->chip->bus_sync_unlock are NULL !
> 
> What does it return?  I can see that -EINVAL is returned if it isn't 
> applicable to this irq.  But what if chip->irq_read_line is implemented?

It returns the logical state of that line (0 when it is low or 1 when it 
is high). Will add the return type in the comment.

> 
> 
> 
> 
>> + */
>> +int irq_read_line(unsigned int irq)
>> +{
>> +    struct irq_desc *desc = irq_to_desc(irq);
>> +    unsigned long flags;
>> +    int val;
>> +
>> +    if (!desc || !desc->irq_data.chip->irq_read_line)
>> +        return -EINVAL;

It returns -EINVAL is irq_read_line is not implemented.

>> +
>> +    chip_bus_lock(desc);
>> +    raw_spin_lock_irqsave(&desc->lock, flags);



--
Sent by an employee of the Qualcomm Innovation Center, Inc. The Qualcomm 
Innovation Center, Inc. is a member of the Code Aurora Forum.
