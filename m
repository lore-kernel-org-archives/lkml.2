Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048Ab0HDBUJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 21:20:09 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:36206 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799Ab0HDBUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 21:20:07 -0400
To: Yinghai Lu <yinghai@kernel.org>
Cc: Dave Airlie <airlied@gmail.com>, Iranna D Ankad <iranna.ankad@in.ibm.com>,
        Gary Hade <garyhade@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Renninger <trenn@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: oops in ioapic_write_entry
References: <AANLkTimeFuABgQHJzq38uJ-4gTQbfSRfQBb91P+NPwCS@mail.gmail.com>
	<AANLkTimqDPvTqOZiBgUn7t4JJhgQU4ShVTsCJEzV=8fR@mail.gmail.com>
	<AANLkTi=sNRwxmv8aKN_jo7tAx6SQ-AOFfAXJxcPnNZQp@mail.gmail.com>
	<4C577197.9020003@kernel.org> <4C57723C.1060400@kernel.org>
	<m1bp9k2xsg.fsf@fess.ebiederm.org> <4C57C319.8070800@kernel.org>
	<m11vagw2fl.fsf@fess.ebiederm.org> <4C57CD9C.70602@kernel.org>
	<m1fwywoz0f.fsf@fess.ebiederm.org> <4C57DACF.1090503@kernel.org>
	<m17hk8oy5g.fsf@fess.ebiederm.org> <4C57E32A.9070401@kernel.org>
	<m18w4onebi.fsf@fess.ebiederm.org> <4C5871BC.4070007@kernel.org>
	<m1bp9jgyww.fsf@fess.ebiederm.org> <4C58ADB2.8060702@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 03 Aug 2010 18:19:55 -0700
In-Reply-To: <4C58ADB2.8060702@kernel.org> (Yinghai Lu's message of "Tue\, 03 Aug 2010 17\:00\:50 -0700")
Message-ID: <m1bp9jdvic.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.4.80;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.4.80
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:

> On 08/03/2010 02:38 PM, Eric W. Biederman wrote:
>> Yinghai Lu <yinghai@kernel.org> writes:
>> 
>>> On 08/03/2010 04:08 AM, Eric W. Biederman wrote:
>>>>
>>>> For the common case I think we still do the right thing, even now, for
>>>> these broken bios tables.  There is likely an uncommon case for which
>>>> something like your shared_legacy_irq deserves to be used, especially
>>>> at it preserves our well tested historical behavior.
>>>
>>> Dave, Irnna, Gary:
>>>
>>> can you check this patch on your systems?
>>>
>>> [PATCH] x86: check if apic/pin is shared with legacy one
>>>
>>> fix system that external device that have io apic on apic0/pin(0-15)
>> 
>> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> 
>> Your patch addresses what appears to be a theoretical issue, caused by
>> a BIOS bug.  So far you have not presented a credible scenario where
>> this would affect anything in real life except the user visible irq
>> number.
>> 
>> Will you please stop, think, and describe what is going on clearly
>> and how you expect this patch to affect anything, and please stop
>> selling this patch as the solution to all of the world's ills.  You
>> are being sloppy and wasting everyone's time.
>
> That is real problem in pin_2_irq()
>
> Nvidia chipset system with legacy bios will have problem when user try to boot with acpi is disabled.
> LinuxBIOS should be ok, already have external devices to use pin above 15.

The Nvidia chipset will have what problem?

> Also your patch does cause kernel crash when acpi is disabled in virtualbox even there
> could be BIOS problem there.
> kernel before your patch does work in that conf.

What is the kernel crash?

I believe you have told me earlier that the problems you see with 2.6.35 are
roughly, while those setups work with 2.3.34?

>  cause kernel with acpi crash in virtual box.
> 
> [    5.536000] querying PCI -> IRQ mapping bus:0, slot:11, pin:0.
> [    5.540000] ehci_hcd 0000:00:0b.0: can't find IRQ for PCI INT A; probably buggy MP table
> [
> 
> and on kvm it got:
> [    4.352280] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k6-NAPI
> [    4.356012] e1000: Copyright (c) 1999-2006 Intel Corporation.
> [    4.360120] querying PCI -> IRQ mapping bus:0, slot:3, pin:0.
> [    4.364006] PCI BIOS passed nonexistent PCI bus 0!
> [    4.368007] e1000 0000:00:03.0: can't find IRQ for PCI INT A; probably buggy MP table
> [    4.372049] e1000 0000:00:03.0: setting latency timer to 64


Can you send out boot log with "debug apic=debug pci=routeirq" for the
working 2.6.34, the failing 2.6.35, and your .config?

With a little luck that will be enough to allow us to pinpoint the
problem case.

Eric

