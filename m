Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451Ab1DOWIg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 18:08:36 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:59181 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757215Ab1DOWIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 18:08:35 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6317"; a="85921154"
Message-ID: <4DA8C1E2.3020205@codeaurora.org>
Date: Fri, 15 Apr 2011 15:08:34 -0700
From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: mathieu.desnoyers@efficios.com, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        dwalker@fifo99.com, linux-arm-msm-owner@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [RFC PATCH] genirq: implement read_irq_line for interrupt lines
References: <1302892952-7090-1-git-send-email-adharmap@codeaurora.org> <alpine.LFD.2.00.1104152058050.2744@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1104152058050.2744@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Fri, 15 Apr 2011, Abhijeet Dharmapurikar wrote:
> 
>> Some drivers need to know what the status of the interrupt line is.
>> This is especially true for drivers that register a handler with
>> IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING and in the handler they
>> need to know which edge transition it was invoked for.
> 
> What's the purpose of this? How is that going to be used?

The main purpose is to know in the handler if it was invoked becuase of 
a rising edge or the falling edge.

Now one could say that the driver should maintain some state and toggle 
it upon each invocation of this handler. That scheme quickly goes out of 
sync because we might ignore interrupts while suspended.

> 
>>  
>>  #ifndef CONFIG_GENERIC_HARDIRQS_NO_COMPAT
> 
> That hunk does not apply.

Will rebase and resend it again, my bad.

>> +int irq_read_line(unsigned int irq)
>> +{
>> +	struct irq_desc *desc = irq_to_desc(irq);
>> +	unsigned long flags;
>> +	int val;
> 
> Please use irq_get_desc_buslock()

yes will fix this in the next revision of this patch.


>> +EXPORT_SYMBOL(irq_read_line);
> 
> EXPORT_SYMBOL_GPL() please.

yes will do


--
Sent by an employee of the Qualcomm Innovation Center, Inc. The Qualcomm 
Innovation Center, Inc. is a member of the Code Aurora Forum.
