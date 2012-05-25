Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298Ab2EZBn4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 21:43:56 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46580 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab2EZBnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 21:43:55 -0400
Message-ID: <4FBFCB39.6000101@landley.net>
Date: Fri, 25 May 2012 13:11:05 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Igor Mammedov <imammedo@redhat.com>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, luto@mit.edu, suresh.b.siddha@intel.com,
        avi@redhat.com, a.p.zijlstra@chello.nl, johnstul@us.ibm.com,
        arjan@linux.intel.com
Subject: Re: [RFC v2] [x86]: abort secondary cpu bringup gracefully
References: <27b5952f-0f5f-418a-9e22-e6ea12980eee@zmail16.collab.prod.int.phx2.redhat.com> <1336993769-15272-1-git-send-email-imammedo@redhat.com> <4FBE56C6.1020901@redhat.com>
In-Reply-To: <4FBE56C6.1020901@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2012 10:41 AM, Igor Mammedov wrote:
> ping for reviewers.
> 
> Please review patch.

I can't hugely comment on the guts of what the patch is doing, but:

>> --- a/arch/x86/kernel/smpboot.c
>> +++ b/arch/x86/kernel/smpboot.c
>> @@ -136,6 +136,10 @@ EXPORT_PER_CPU_SYMBOL(cpu_info);
>>
>>   atomic_t init_deasserted;
>>
>> +#ifdef CONFIG_HOTPLUG_CPU
>> +static void remove_siblinginfo(int cpu);
>> +#endif
>> +

#ifdefs should almost never be in C code, they should be in header
files. You can stub out functions with empty inline versions.  For a
random example, see kernel/smpboot.h

Rob
-- 
GNU/Linux isn't: Linux=GPLv2, GNU=GPLv3+, they can't share code.
Either it's "mere aggregation", or a license violation.  Pick one.
