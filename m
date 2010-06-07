Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab0FGVFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 17:05:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52368 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752550Ab0FGVFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 17:05:42 -0400
Message-ID: <4C0D5F0D.7050706@zytor.com>
Date: Mon, 07 Jun 2010 14:05:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Yinghai <yinghai.lu@oracle.com>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>,
       Jacob Pan <jacob.jun.pan@intel.com>
Subject: Re: [tip:x86/irq] x86, acpi/irq: Handle isa irqs that are not identity
 mapped to gsi's.
References: <1269936436-7039-14-git-send-email-ebiederm@xmission.com>	<tip-988856ee1623bd37e384105f7bb2b7fe44c009f6@git.kernel.org>	<4BE12323.2010104@oracle.com> <m1y6fy4rsp.fsf@fess.ebiederm.org>
In-Reply-To: <m1y6fy4rsp.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2010 02:32 AM, Eric W. Biederman wrote:
>>
>> can you use legacy_irq->nr_legacy_irqs instead of NR_IRQS_LEGACY ?
> 
> No. legacy_irq->nr_legacy_irqs is just for dealing with hardware that
> does not have i8259 pics.
> 

I don't know if it is "just" for this purpose.  Quite on the contrary.
In fact, the fact that NR_IRQS_LEGACY is showing up at all looks like a
real problem.

> Here I am reserving 16 irqs above the gsi range in case we get a
> weird gsi to isa irq mapping.

But that 16 is exactly because those are the (platform-specific) legacy
IRQs.

> Currently the sfi spec doesn't mention anything explicitly.  I
> took a quick read through it and sfi and I presume Moorestown
> is talking about non pci irqs.  So I would not be surprised
> if we didn't have isa device drivers running on platforms
> without i8259s.

I'm confused about the above.  Where do you see any mention to fixed
(ISA) IRQs in SFI or Moorestown?  Jacob tells me they don't exist.

> Currently the code had a small bug dealing with multiple ioapics and
> the spec really is incomplete about how you map irqs from pci devices
> to interrupts.  So it looks like SFI and Moorestown are more a lab
> experiment than real hardware at the moment.  So I expect when
> it gets completely fleshed out we will have to jump through a
> similar set of hoops as we do with acpi to ensure the first 16
> irqs are not used for anything except isa irqs.

Moorestown hardware certainly exists, although not all the support is
upstream yet.

Either which way, anything which perpetuates NR_IRQS_LEGACY as a
compile-time constant is begging for people to get things wrong, and it
really needs to go away.

	-hpa
