Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab2FEPfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 11:35:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55391 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab2FEPfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 11:35:52 -0400
Message-ID: <4FCE2747.3050308@gmail.com>
Date: Tue, 05 Jun 2012 23:35:35 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
        H Peter Anvin <hpa@zytor.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Arjan Dan De Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 0/6] x86/cpu hotplug: Wake up offline CPU via mwait or
 nmi
References: <1338833876-29721-1-git-send-email-fenghua.yu@intel.com> <alpine.LFD.2.02.1206042203590.3086@ionos>
In-Reply-To: <alpine.LFD.2.02.1206042203590.3086@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,
	It's a great idea to use state machine to implement cpu online/offline.
Actually we are trying to split the cpu online/offline flow into several stages
so we could do error recover easily when hot-plugging physical processors.
	Thanks!
	Gerry

On 06/05/2012 04:11 AM, Thomas Gleixner wrote:
> On Mon, 4 Jun 2012, Fenghua Yu wrote:
> 
>> From: Fenghua Yu <fenghua.yu@intel.com>
>>
>> Since offline CPU is in wmait or hlt if mwait feature is not available, it can
>> be waken up by writing to monitored memory range or via nmi.
>>
>> Compared to current INIT, INIT, STARTUP wake up sequence, waking up offline CPU
>> is faster via wmait or nmi. This is especially useful when offline CPU for
>> power saving and shorter waking up time is desired. On one tested desktop
>> machine, waking up time via mwait or nmi is reduced to 23% of waking up time
>> via INIT. Waking up time is measured from the beginning of store_online() to
>> the beginning of cpu_idle() after the CPU is waken up.
>>
>> Waking up offline CPU via mwait or nmi is also useful to support BSP offline/
>> online because offline BSP can not be waken up by the INIT's sequence. The BSP
>> offline/online patchset will be sent out seperately.
> 
> I understand what you are trying to do, though I completely disagree
> with the solution.
> 
> The main problem of the current hotplug code is that it is an all or
> nothing approach. You have to tear down the whole thing completely
> instead of just taking it out of the usable set of cpus.
> 
> I'm working on a proper state machine driven online/offline sequence,
> where you can put the cpu into an intermediate state which avoids
> bringing it down completely. This is enough to get the full
> powersaving benefits w/o having to go through all the synchronization
> states of a full online/offline. That will shorten the onlining time
> of an previously offlined cpu to almost nothing.
> 
> I really want to avoid adding more bandaids to the hotplug code before
> we have sorted out the existing horror.
> 
> Thanks,
> 
> 	tglx
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

