Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509Ab0FHWUm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 18:20:42 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:33885 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932211Ab0FHWUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 18:20:39 -0400
Message-ID: <4C0EC212.3010400@oracle.com>
Date: Tue, 08 Jun 2010 15:20:02 -0700
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>,
       Jacob Pan <jacob.jun.pan@intel.com>
Subject: Re: [tip:x86/irq] x86, acpi/irq: Handle isa irqs that are not identity
 mapped to gsi's.
References: <1269936436-7039-14-git-send-email-ebiederm@xmission.com>	<tip-988856ee1623bd37e384105f7bb2b7fe44c009f6@git.kernel.org>	<4BE12323.2010104@oracle.com> <m1y6fy4rsp.fsf@fess.ebiederm.org> <4C0D5F0D.7050706@zytor.com>
In-Reply-To: <4C0D5F0D.7050706@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090209.4C0EC226.019F:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2010 02:05 PM, H. Peter Anvin wrote:
> On 05/05/2010 02:32 AM, Eric W. Biederman wrote:
>>>
>>> can you use legacy_irq->nr_legacy_irqs instead of NR_IRQS_LEGACY ?
>>
>> No. legacy_irq->nr_legacy_irqs is just for dealing with hardware that
>> does not have i8259 pics.
>>
> 
> I don't know if it is "just" for this purpose.  Quite on the contrary.
> In fact, the fact that NR_IRQS_LEGACY is showing up at all looks like a
> real problem.
> 
>> Here I am reserving 16 irqs above the gsi range in case we get a
>> weird gsi to isa irq mapping.
> 
> But that 16 is exactly because those are the (platform-specific) legacy
> IRQs.
> 
>> Currently the sfi spec doesn't mention anything explicitly.  I
>> took a quick read through it and sfi and I presume Moorestown
>> is talking about non pci irqs.  So I would not be surprised
>> if we didn't have isa device drivers running on platforms
>> without i8259s.
> 
> I'm confused about the above.  Where do you see any mention to fixed
> (ISA) IRQs in SFI or Moorestown?  Jacob tells me they don't exist.
> 
>> Currently the code had a small bug dealing with multiple ioapics and
>> the spec really is incomplete about how you map irqs from pci devices
>> to interrupts.  So it looks like SFI and Moorestown are more a lab
>> experiment than real hardware at the moment.  So I expect when
>> it gets completely fleshed out we will have to jump through a
>> similar set of hoops as we do with acpi to ensure the first 16
>> irqs are not used for anything except isa irqs.
> 
> Moorestown hardware certainly exists, although not all the support is
> upstream yet.
> 
> Either which way, anything which perpetuates NR_IRQS_LEGACY as a
> compile-time constant is begging for people to get things wrong, and it
> really needs to go away.

yes, it should be replaced legacy_irq->nr_legacy_irs to make Moorestown to have sane irq index.

otherwise gsi_to_irq will mapping all [0, 15] to start from nr_irqs_gsi.

Thanks

Yinghai
