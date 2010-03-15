Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965629Ab0COWQr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 18:16:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:50592 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964968Ab0COWQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 18:16:46 -0400
Message-ID: <4B9EB185.3010400@kernel.org>
Date: Mon, 15 Mar 2010 15:15:33 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch] x86: handle legacy PIC interrupts on all the cpu's
References: <1268692386.3296.43.camel@sbs-t61.sc.intel.com>	 <4B9EABE8.1020203@kernel.org> <1268693771.3296.49.camel@sbs-t61.sc.intel.com>
In-Reply-To: <1268693771.3296.49.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2010 03:56 PM, Suresh Siddha wrote:
> On Mon, 2010-03-15 at 14:51 -0700, Yinghai Lu wrote:
>>> +	for (irq = 0; irq < legacy_pic->nr_legacy_irqs; irq++)
>>> +		if (!IO_APIC_IRQ(irq))
>>> +			per_cpu(vector_irq, cpu)[IRQ0_VECTOR + irq] = irq;
>>
>> seems those three lines are not needed...
> 
> Those are needed for !CONFIG_X86_IO_APIC case.
> 
then we can have

+#ifndef CONFIG_X86_IO_APIC
+	for (irq = 0; irq < legacy_pic->nr_legacy_irqs; irq++)
+		per_cpu(vector_irq, cpu)[IRQ0_VECTOR + irq] = irq;
+#endif

then we don't punish most setup with ioapic controller.

Yinghai
