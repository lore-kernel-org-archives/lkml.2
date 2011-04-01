Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab1DAGnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 02:43:35 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:37678 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512Ab1DAGne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 02:43:34 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ingo Molnar <mingo@elte.hu>
Cc: Florian Mickler <florian@mickler.org>, linux-kernel@vger.kernel.org,
        kurup_avinash@yahoo.com, maciej.rutecki@gmail.com, rjw@sisk.pl,
        sedat.dilek@gmail.com, stable@kernel.org, #.34+@schatten.dmk.lab
Subject: Re: [PATCH v2] x86, ioapic: Skip looking for ioapic overrides when ioapics are not present
References: <20110331084342.GA30105@elte.hu>
	<1301621025-3858-1-git-send-email-florian@mickler.org>
	<20110401062006.GC32378@elte.hu>
Date: Thu, 31 Mar 2011 23:43:27 -0700
In-Reply-To: <20110401062006.GC32378@elte.hu> (Ingo Molnar's message of "Fri,
	1 Apr 2011 08:20:06 +0200")
Message-ID: <m1y63uv5dc.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18VjOMAgygcsYw40ffYnxFszDJ/VfAhVyQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Florian Mickler <florian@mickler.org> wrote:
>
>> --- a/arch/x86/kernel/apic/io_apic.c
>> +++ b/arch/x86/kernel/apic/io_apic.c
>> @@ -3789,6 +3789,10 @@ int acpi_get_override_irq(u32 gsi, int *trigger, int *polarity)
>>  {
>>  	int ioapic, pin, idx;
>>  
>> +#ifdef CONFIG_ACPI
>> +	if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
>> +		return -1;
>> +#endif
>
> That #ifdef is very ugly. Please introduce a suitable helper function in 
> arch/x86/include/asm/acpi.h - acpi_irq_ioapic_model() or so, which could be 
> used like this:
>
> 	if (!acpi_irq_ioapic_model())
> 		return -1;
>
> And would be defined in the !CONFIG_ACPI case as well.

If you want clean this function needs to be moved out of io_apic.c where
into acpi.c where it belongs.  I don't know that going that far to fix
an annoying warning message is warranted.  The function should only have
callers when acpi is compiled so it is safe to make the entire function
#ifdef ACPI. 

A silly helper in acpi.h is definitely the wrong way to go.

Eric

