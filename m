Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933352Ab1LFLZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 06:25:49 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:43741 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009Ab1LFLZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 06:25:36 -0500
Message-ID: <4EDDFB8E.10801@linux.vnet.ibm.com>
Date: Tue, 06 Dec 2011 16:55:02 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Fenghua Yu <fenghua.yu@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Len Brown <len.brown@intel.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>, x86 <x86@kernel.org>,
        Tejun Heo <tj@kernel.org>, Borislav Petkov <bp@amd64.org>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>
Subject: Re: [PATCH v4 0/7] x86: BSP or CPU0 online/offline
References: <1321075592-31600-1-git-send-email-fenghua.yu@intel.com> <20111206084230.GC30062@elte.hu> <20111206085816.GA11116@elte.hu> <4EDDE5D0.7030906@linux.vnet.ibm.com> <20111206103500.GD15966@elte.hu> <4EDDF2DE.7020701@linux.vnet.ibm.com>
In-Reply-To: <4EDDF2DE.7020701@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11120601-0260-0000-0000-0000002C9972
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2011 04:17 PM, Srivatsa S. Bhat wrote:

> On 12/06/2011 04:05 PM, Ingo Molnar wrote:
> 
>>
>> * Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>>
>>>> But the hibernation angle should be considered. Hibernation 
>>>> already has to deal with the case where someone physically 
>>>> unplugs a CPU and then resumes from the disk image, right? 
>>>> How does the hibernation code handle that case currently?
>>>
>>> Oh, wait a minute. Are we talking about physical CPU Hotplug 
>>> in between hibernation and restore? AFAIK, currently we don't 
>>> handle that at all. [...]
>>
>> Well, not hotplug, but plain old-fashioned: 'hibernate the box, 
>> take out a CPU physically and thaw' kind of hardware change.
>>
> 
> 
> Well, actually that's what I meant, taking this same idea a bit
> further: hibernate the box, take out a CPU physically, insert a
> slightly different CPU (which needs a different microcode image)
> and thaw.
> 
> In this case, the other patch that I mentioned in my previous mail
> would be required (or an equivalent), because the optimization
> patch which is now in mainline, would apply the same old microcode
> image on this new CPU too, blindly.
> 


By the way, this problem is not tied to CPU0 alone, it exists for any
CPU! (as long as we are talking about plugging in/out CPUs physically).

Regards,
Srivatsa S. Bhat

