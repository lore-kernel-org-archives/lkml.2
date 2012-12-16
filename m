Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591Ab2LPTmu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 14:42:50 -0500
Received: from static.121.164.40.188.clients.your-server.de ([188.40.164.121]:51732
	"EHLO smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab2LPTmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 14:42:49 -0500
Date: Sun, 16 Dec 2012 20:42:44 +0100
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <315845667.20121216204244@eikelenboom.it>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: xen-devel <xen-devel@lists.xen.org>, linux-kernel@vger.kernel.org
Subject: Re: 3.8.0-rc0 on xen-unstable: RCU Stall during boot as dom0 kernel after IOAPIC
In-Reply-To: <20121216173824.GA4518@phenom.dumpdata.com>
References: <1995613404.20121214165557@eikelenboom.it> <20121216173824.GA4518@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sunday, December 16, 2012, 6:38:24 PM, you wrote:

> On Fri, Dec 14, 2012 at 04:55:57PM +0100, Sander Eikelenboom wrote:
>> Hi Konrad,
>> 
>> I just tried to boot a 3.8.0-rc0 kernel (last commit: 7313264b899bbf3988841296265a6e0e8a7b6521) as dom0 on my machine with current xen-unstable.

> Yeah, saw it over the Dec 11->Dec 12 merges and was out on
> vacation during that time (just got back).

> Did you by any chance try to do a git bisect to narrow down
> which merge it was?

Hi Konrad,

Nope haven't had the time, I only tried resetting to commit 189251705649bdfdf5e5850eb178f8cbfdac5480 as a "hunch"(just before a lot of x86 and rcu commits), but the result didn't boot ..

--
Sander

> Thanks!
>> The boot stalls:
>> 
>> [    0.000000] ACPI: PM-Timer IO Port: 0x808
>> [    0.000000] ACPI: Local APIC address 0xfee00000
>> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
>> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
>> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
>> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
>> [    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x04] enabled)
>> [    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] enabled)
>> [    0.000000] ACPI: IOAPIC (id[0x06] address[0xfec00000] gsi_base[0])
>> [    0.000000] IOAPIC[0]: apic_id 6, version 33, address 0xfec00000, GSI 0-23
>> [    0.000000] ACPI: IOAPIC (id[0x07] address[0xfec20000] gsi_base[24])
>> [    0.000000] IOAPIC[1]: apic_id 7, version 33, address 0xfec20000, GSI 24-
>> [   64.598628] INFO: rcu_preempt detected stalls on CPUs/tasks:
>> [   64.598676]  0: (1 GPs behind) idle=aed/140000000000000/0 drain=5 . timer not pending
>> [   64.598683]  (detected by 1, t=18004 jiffies, g=18446744073709551414, c=18446744073709551413, q=162)
>> [   64.598692] sending NMI to all CPUs:
>> [   64.598716] xen: vector 0x2 is not implemented
>> 
>> 
>> Perhaps an interesting line is the incomplete (no end of range, and it stalls there some time before the kernel reports the stall itself:
>> [    0.000000] IOAPIC[1]: apic_id 7, version 33, address 0xfec20000, GSI 24-
>> 
>> 
>> The exact seem config with 3.7.0 as kernel works fine.
>> Complete serial log is attached.
>> 
>> --
>> 
>> Sander
>> 
>> 




