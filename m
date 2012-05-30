Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab2E3QjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 12:39:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391Ab2E3QjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 12:39:17 -0400
Message-ID: <4FC64D0C.5090603@redhat.com>
Date: Wed, 30 May 2012 18:38:36 +0200
From: Igor Mammedov <imammedo@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, luto@mit.edu, suresh.b.siddha@intel.com,
        avi@redhat.com, a.p.zijlstra@chello.nl, johnstul@us.ibm.com,
        arjan@linux.intel.com
Subject: Re: [RFC v2] [x86]: abort secondary cpu bringup gracefully
References: <27b5952f-0f5f-418a-9e22-e6ea12980eee@zmail16.collab.prod.int.phx2.redhat.com> <1336993769-15272-1-git-send-email-imammedo@redhat.com> <4FBE56C6.1020901@redhat.com> <4FBFCB39.6000101@landley.net>
In-Reply-To: <4FBFCB39.6000101@landley.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2012 08:11 PM, Rob Landley wrote:
> On 05/24/2012 10:41 AM, Igor Mammedov wrote:
>> ping for reviewers.
>>
>> Please review patch.
>
> I can't hugely comment on the guts of what the patch is doing, but:
>
>>> --- a/arch/x86/kernel/smpboot.c
>>> +++ b/arch/x86/kernel/smpboot.c
>>> @@ -136,6 +136,10 @@ EXPORT_PER_CPU_SYMBOL(cpu_info);
>>>
>>>    atomic_t init_deasserted;
>>>
>>> +#ifdef CONFIG_HOTPLUG_CPU
>>> +static void remove_siblinginfo(int cpu);
>>> +#endif
>>> +
>
> #ifdefs should almost never be in C code, they should be in header
> files. You can stub out functions with empty inline versions.  For a
> random example, see kernel/smpboot.h

If it were not just local function, then I'd do so. But since this
function is used only in this file and defined under the same #ifdefs
after smp_callin(), it could stay there and not pollute headers
with non public function declaration.

I made remove_siblinginfo() a forward declaration  before smp_callin(),
because of I didn't have much justification to move ~20 lines function
to be available a bit earlier that it is now.

However thanks for mentioning stubs. I should add stub for building
kernel without CONFIG_HOTPLUG_CPU, to prevent build breakage.

I'll fix and repost patch.

-- 
-----
  Igor
