Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758977Ab1CCWK3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 17:10:29 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53802 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758655Ab1CCWK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 17:10:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=KpVpEooahLfflvjcfsuUGB6WAdBHbHXqnp12vCuGnCFZt86P2/QuJd32wlILtN4pz8
         13KI0ogSH8Dei7RqB/gTcXtlO57PssaaVgxe10RqF6BVKfWWDrZuWs81A1kJ9w3Qo392
         2Cf0UNWXxYPruX+wwFvFMaG9a84T6nmlvU1GI=
Message-ID: <4D7011CE.6060306@gmail.com>
Date: Fri, 04 Mar 2011 01:10:22 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        tglx@linutronix.de, brgerst@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] x86, mm: Clean up initmem_init
References: <tip-ffe77a4605fb2588f8666850ad3e3b196241658f@git.kernel.org> <alpine.DEB.2.00.1102191906180.31263@chino.kir.corp.google.com> <20110221083511.GC31267@htj.dyndns.org> <alpine.DEB.2.00.1103031231060.9993@chino.kir.corp.google.com> <4D700B93.2080807@gmail.com> <alpine.DEB.2.00.1103031359070.4141@chino.kir.corp.google.com> <4D701015.2040703@kernel.org> <alpine.DEB.2.00.1103031404510.4141@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1103031404510.4141@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2011 01:05 AM, David Rientjes wrote:
> On Thu, 3 Mar 2011, Yinghai Lu wrote:
> 
>> he want
>>
>>> +#ifdef CONFIG_ACPI_NUMA
>>>>> +		ret = numa_init(x86_acpi_numa_init);
>>>>> +		if (!ret)
>>>>> +			return;
>>>>> +#endif
>>>>> +#ifdef CONFIG_AMD_NUMA
>>>>> +		ret = numa_init(amd_numa_init);
>>>>> +		if (!ret)
>>>>> +			return;
>>>>> +#endif
>>
>> to be replaced by:
>>
>>> +#ifdef CONFIG_ACPI_NUMA
>>>>> +		if (!numa_init(x86_acpi_numa_init))
>>>>> +			return;
>>>>> +#endif
>>>>> +#ifdef CONFIG_AMD_NUMA
>>>>> +		if (!numa_init(amd_numa_init))
>>>>> +			return;
>>>>> +#endif
> 
> It's a matter of style and I think it's up to Ingo what he'd prefer to 
> see.

i'm fine with either, just though it would shrink the code a bit (since there
is no need to track var witch i guess will be eliminated by gcc anyway).

nb: am i only the one who obtain bounce from shaohui.zheng@intel.com (so i'd to remove
him from cc'ing)?
-- 
    Cyrill
