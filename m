Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab0HCIAw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 04:00:52 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:59138 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654Ab0HCIAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 04:00:51 -0400
To: Yinghai Lu <yinghai@kernel.org>
Cc: Dave Airlie <airlied@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: oops in ioapic_write_entry
References: <AANLkTimeFuABgQHJzq38uJ-4gTQbfSRfQBb91P+NPwCS@mail.gmail.com>
	<AANLkTimqDPvTqOZiBgUn7t4JJhgQU4ShVTsCJEzV=8fR@mail.gmail.com>
	<AANLkTi=sNRwxmv8aKN_jo7tAx6SQ-AOFfAXJxcPnNZQp@mail.gmail.com>
	<4C577197.9020003@kernel.org> <4C57723C.1060400@kernel.org>
	<m1bp9k2xsg.fsf@fess.ebiederm.org> <4C57C319.8070800@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 03 Aug 2010 01:00:46 -0700
In-Reply-To: <4C57C319.8070800@kernel.org> (Yinghai Lu's message of "Tue\, 03 Aug 2010 00\:19\:53 -0700")
Message-ID: <m11vagw2fl.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.188.4.80;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.4.80
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:

>>> Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
>>> ===================================================================
>>> --- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
>>> +++ linux-2.6/arch/x86/kernel/apic/io_apic.c
>>> @@ -1029,10 +1029,7 @@ static int pin_2_irq(int idx, int apic,
>>>  	} else {
>>>  		u32 gsi = mp_gsi_routing[apic].gsi_base + pin;
>>>  
>>> -		if (gsi >= NR_IRQS_LEGACY)
>>> -			irq = gsi;
>>> -		else
>>> -			irq = gsi_top + gsi;
>>> +		irq = gsi_to_irq(gsi);
>>>  	}
>>>  
>>>  #ifdef CONFIG_X86_32
>
> what is the point for making irq = gsi_top + gsi when mptable is used instead of acpi?

Because it is only convention that when mptables are used that the
first apic pins 0-15 are the ISA irqs.  This thread witnessed and a
pci irq that came in pin < 16 that was not an ISA irq.  The truly rare
and exotic case would be for the ISA irqs to be outside the first 16
ioapic pins but the es7000 did exactly that.

Eric
