Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab1EPIYK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 04:24:10 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:54832 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab1EPIYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 04:24:08 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4DD0DFCA.9050502@cam.ac.uk>
Date: Mon, 16 May 2011 09:26:50 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110509 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irq: export handle_simple_irq, irq_modify_status, irq_to_desc,
 irq_alloc_descs and irq_free_descs
References: <1304525890-11915-1-git-send-email-jic23@cam.ac.uk> <4DCA5A97.90704@cam.ac.uk> <4DCD3696.3090804@cam.ac.uk> <alpine.LFD.2.02.1105131712520.2799@ionos> <4DCD50BF.2030308@cam.ac.uk> <alpine.LFD.2.02.1105141751490.3078@ionos>
In-Reply-To: <alpine.LFD.2.02.1105141751490.3078@ionos>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/11 16:52, Thomas Gleixner wrote:
> On Fri, 13 May 2011, Jonathan Cameron wrote:
> 
>> On 05/13/11 16:17, Thomas Gleixner wrote:
>>> On Fri, 13 May 2011, Jonathan Cameron wrote:
>>>
>>>> Hi Thomas.
>>>>
>>>> Just a quick request that you give a yes or no to this.
>>>>
>>>> Thanks and sorry for repeated pestering!
>>>
>>> Sorry for the delay.
>>>  
>>>>>>  /**
>>>>>>   *	irq_cpu_online - Invoke all irq_cpu_online functions.
>>>>>> diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
>>>>>> index 2c039c9..5ac14e2 100644
>>>>>> --- a/kernel/irq/irqdesc.c
>>>>>> +++ b/kernel/irq/irqdesc.c
>>>>>> @@ -110,6 +110,7 @@ struct irq_desc *irq_to_desc(unsigned int irq)
>>>>>>  {
>>>>>>  	return radix_tree_lookup(&irq_desc_tree, irq);
>>>>>>  }
>>>>>> +EXPORT_SYMBOL_GPL(irq_to_desc);
>>>
>>> I'm fine with that, just this one makes me a bit wary.
>> It does feel a little fishy. For reference of others - it's required as
>> generic_handle_irq is inline in the irqdesc.h and uses it.
> 
> I know and there is no real reason why generic_handle_irq needs to be
> inline.

So you would be happy with moving generic_handle_irq implementation
out of irqdesc.h and exporting that instead of irq_to_desc?

The element that isn't obvious to me is where should generic_handle_irq go?
(i.e. which file?)  I'm afraid I'm not familiar enough with the generic irq
stuff to get this right!

Thanks,

Jonathan
