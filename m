Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214Ab0HDAiM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 20:38:12 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:50390 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799Ab0HDAiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 20:38:11 -0400
Message-ID: <4C58ADB2.8060702@kernel.org>
Date: Tue, 03 Aug 2010 17:00:50 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Dave Airlie <airlied@gmail.com>, Iranna D Ankad <iranna.ankad@in.ibm.com>,
        Gary Hade <garyhade@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Renninger <trenn@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: oops in ioapic_write_entry
References: <AANLkTimeFuABgQHJzq38uJ-4gTQbfSRfQBb91P+NPwCS@mail.gmail.com>	<AANLkTimqDPvTqOZiBgUn7t4JJhgQU4ShVTsCJEzV=8fR@mail.gmail.com>	<AANLkTi=sNRwxmv8aKN_jo7tAx6SQ-AOFfAXJxcPnNZQp@mail.gmail.com>	<4C577197.9020003@kernel.org> <4C57723C.1060400@kernel.org>	<m1bp9k2xsg.fsf@fess.ebiederm.org> <4C57C319.8070800@kernel.org>	<m11vagw2fl.fsf@fess.ebiederm.org> <4C57CD9C.70602@kernel.org>	<m1fwywoz0f.fsf@fess.ebiederm.org> <4C57DACF.1090503@kernel.org>	<m17hk8oy5g.fsf@fess.ebiederm.org> <4C57E32A.9070401@kernel.org>	<m18w4onebi.fsf@fess.ebiederm.org> <4C5871BC.4070007@kernel.org> <m1bp9jgyww.fsf@fess.ebiederm.org>
In-Reply-To: <m1bp9jgyww.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4C58B661.02E5,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2010 02:38 PM, Eric W. Biederman wrote:
> Yinghai Lu <yinghai@kernel.org> writes:
> 
>> On 08/03/2010 04:08 AM, Eric W. Biederman wrote:
>>>
>>> For the common case I think we still do the right thing, even now, for
>>> these broken bios tables.  There is likely an uncommon case for which
>>> something like your shared_legacy_irq deserves to be used, especially
>>> at it preserves our well tested historical behavior.
>>
>> Dave, Irnna, Gary:
>>
>> can you check this patch on your systems?
>>
>> [PATCH] x86: check if apic/pin is shared with legacy one
>>
>> fix system that external device that have io apic on apic0/pin(0-15)
> 
> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> Your patch addresses what appears to be a theoretical issue, caused by
> a BIOS bug.  So far you have not presented a credible scenario where
> this would affect anything in real life except the user visible irq
> number.
> 
> Will you please stop, think, and describe what is going on clearly
> and how you expect this patch to affect anything, and please stop
> selling this patch as the solution to all of the world's ills.  You
> are being sloppy and wasting everyone's time.

That is real problem in pin_2_irq()

Nvidia chipset system with legacy bios will have problem when user try to boot with acpi is disabled.
LinuxBIOS should be ok, already have external devices to use pin above 15.

Also your patch does cause kernel crash when acpi is disabled in virtualbox even there
could be BIOS problem there.
kernel before your patch does work in that conf.

Yinghai
