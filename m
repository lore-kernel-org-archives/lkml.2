Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab2GTXey (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 19:34:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44091 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab2GTXex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 19:34:53 -0400
Message-ID: <5009EB16.1070809@gmail.com>
Date: Fri, 20 Jul 2012 17:34:46 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf with precise attribute kills all KVM based VMs
References: <4FFAE6D8.5050609@gmail.com> <20120709141904.GC7298@redhat.com> <1341843844.3462.75.camel@twins> <4FFAED16.7050204@redhat.com> <4FFAEF13.7010108@gmail.com> <1341845396.3462.81.camel@twins> <4FFAEFF1.9000706@redhat.com> <1341845999.3462.86.camel@twins> <4FFCBD00.1030109@gmail.com> <20120711071006.GF23898@redhat.com>
In-Reply-To: <20120711071006.GF23898@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/11/12 1:10 AM, Gleb Natapov wrote:
> Looks like Avi is right about the overshoot. Can you test something like this?
>
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index 166546e..5fb371a 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -1374,8 +1374,11 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr)
>   	arr[0].msr = MSR_CORE_PERF_GLOBAL_CTRL;
>   	arr[0].host = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_guest_mask;
>   	arr[0].guest = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_host_mask;
> +	arr[1].msr = MSR_IA32_PEBS_ENABLE;
> +	arr[1].host = cpuc->pebs_enabled;
> +	arr[1].guest = 0;
> +	*nr = 2;
>
> -	*nr = 1;
>   	return arr;
>   }


Tested-by: David Ahern <dsahern@gmail.com>

Peter's patch is required as well. It's the combination that fixes the 
problem.

David
