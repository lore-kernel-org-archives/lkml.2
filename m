Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933424Ab1LFOP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 09:15:58 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:47019 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933284Ab1LFOPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 09:15:55 -0500
Message-ID: <4EDE2388.7080806@linux.vnet.ibm.com>
Date: Tue, 06 Dec 2011 19:45:36 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Fenghua Yu <fenghua.yu@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Len Brown <len.brown@intel.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH v4 0/7] x86: BSP or CPU0 online/offline
References: <1321075592-31600-1-git-send-email-fenghua.yu@intel.com> <20111206084230.GC30062@elte.hu>
In-Reply-To: <20111206084230.GC30062@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11120604-7014-0000-0000-00000037E5FC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2011 02:12 PM, Ingo Molnar wrote:

> 
> * Fenghua Yu <fenghua.yu@intel.com> wrote:
> 
>> From: Fenghua Yu <fenghua.yu@intel.com>
>>
>> BSP or CPU0 has been the last obstacle to CPU hotplug on x86. 
>> This patch set implements BSP online and offline and removes 
>> this obstacle to CPU hotplug.

[snip]
> 

> Also, could you please enumerate all limitations that could 
> possibly happen? The documentation has this list right now:
> 
> +1. Resume from hibernate/suspend depends on BSP. Hibernate/suspend will fail if
> +BSP is offline and you need to online BSP before hibernate/suspend can continue.
> 
> This needs to be fixed on some other fashion than warning people 
> in documentation that it would break.
> 


Actually, this patchset does more than just warn people. It has
checks to see if the CPU0 is offline, and if so, it fails the
suspend/hibernate attempt. See patch 7/7
(x86/power/cpu.c: Don't hibernate/suspend if CPU0 is offline)

> Firstly, at minimum a suspend/hibernate attempt should fail in 
> some deterministic fashion.


It does, as mentioned above. In fact, this patchset does it
proactively: whether the hardware/firmware supports suspend/resume
with BSP offlined or not, it just prevents anybody from doing
suspend/hibernate when the boot CPU is offline.

I am not saying that this is the *right* way to do it; I am just
pointing out that this patchset _does_ handle it.

> 
> Secondly, and more importantly, is there *any* hardware in 
> existence that has a BIOS that can suspend/resume successfully 
> with BSP offlined? If such hardware exists then we need to 
> support it properly - initially perhaps by whitelisting such 
> systems.
> 
> Then if demand for this picks up some more intelligent method of 
> cooperating with the firmware could be added: the firmware could 
> actually signal to us whether it supports suspend/resume from 
> other than the boot CPU.
> 

 
Regards,
Srivatsa S. Bhat

