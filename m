Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163Ab1EMPhG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 11:37:06 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:54369 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab1EMPhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 11:37:05 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4DCD50BF.2030308@cam.ac.uk>
Date: Fri, 13 May 2011 16:39:43 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110509 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irq: export handle_simple_irq, irq_modify_status, irq_to_desc,
 irq_alloc_descs and irq_free_descs
References: <1304525890-11915-1-git-send-email-jic23@cam.ac.uk> <4DCA5A97.90704@cam.ac.uk> <4DCD3696.3090804@cam.ac.uk> <alpine.LFD.2.02.1105131712520.2799@ionos>
In-Reply-To: <alpine.LFD.2.02.1105131712520.2799@ionos>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/11 16:17, Thomas Gleixner wrote:
> On Fri, 13 May 2011, Jonathan Cameron wrote:
> 
>> Hi Thomas.
>>
>> Just a quick request that you give a yes or no to this.
>>
>> Thanks and sorry for repeated pestering!
> 
> Sorry for the delay.
>  
>>>>  /**
>>>>   *	irq_cpu_online - Invoke all irq_cpu_online functions.
>>>> diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
>>>> index 2c039c9..5ac14e2 100644
>>>> --- a/kernel/irq/irqdesc.c
>>>> +++ b/kernel/irq/irqdesc.c
>>>> @@ -110,6 +110,7 @@ struct irq_desc *irq_to_desc(unsigned int irq)
>>>>  {
>>>>  	return radix_tree_lookup(&irq_desc_tree, irq);
>>>>  }
>>>> +EXPORT_SYMBOL_GPL(irq_to_desc);
> 
> I'm fine with that, just this one makes me a bit wary.
It does feel a little fishy. For reference of others - it's required as
generic_handle_irq is inline in the irqdesc.h and uses it.
> I have a closer
> look over the weekend.
> 
> Thanks,
Thanks,
> 
> 	tglx
> 

