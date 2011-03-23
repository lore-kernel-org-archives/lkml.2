Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab1CWJbT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 05:31:19 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:42511 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755693Ab1CWJbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 05:31:18 -0400
Message-ID: <4D89BDE2.9040606@linux.vnet.ibm.com>
Date: Wed, 23 Mar 2011 15:01:14 +0530
From: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc11 Thunderbird/3.0.5
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: arjan@linux.intel.com, peterz@infradead.org, suresh.b.siddha@intel.com,
        benh@kernel.crashing.org, venki@google.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
        xen-devel@lists.xensource.com
Subject: Re: [RFC PATCH V4 3/5] cpuidle: default idle driver for x86
References: <20110322123208.28725.30945.stgit@tringupt.in.ibm.com> <20110322123244.28725.32435.stgit@tringupt.in.ibm.com> <alpine.LFD.2.02.1103222304300.10549@x980>
In-Reply-To: <alpine.LFD.2.02.1103222304300.10549@x980>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 03/23/2011 08:43 AM, Len Brown wrote:
> Why is this patch a step forward?

Hi Len,

I have basically moved the code for arch default and mwait
idle from arch/x86/kernel/process.c to a driver. This was
suggested by Venki (https://lkml.org/lkml/2010/10/19/460)
as part of pm_idle cleanup and direct call of
cpuidle_idle_call(). There is not much new code here.

>
>> +obj-$(CONFIG_X86)                              += default_driver.o
>
> BTW, that's a pretty generic name for an x86 specific idle driver...
>
> I think that on builds that support intel_idle and acpi_idle,
> everything in this file will be unused, unless somebody uses some
> debugging cmdline params that should have been deleted ages ago.

Yes, I agree that the name has to be x86 specific. I think the
routines would be used for pre-nehalem architectures that use
arch default or mwait.

Thanks,
-Trinabh

>
> thanks,
> Len Brown, Intel Open Source Technology Center
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
