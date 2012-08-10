Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab2HJFXp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 01:23:45 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:46114 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab2HJFXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 01:23:44 -0400
Message-ID: <50249ABD.5060600@in.ibm.com>
Date: Fri, 10 Aug 2012 10:53:09 +0530
From: "Suzuki K. Poulose" <suzuki@in.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: linux-kernel@vger.kernel.org, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakaynahalli <ananth@in.ibm.com>, stan_shebs@mentor.com
Subject: Re: [PATCH 3/5] uprobes: remove check for uprobe variable in handle_swbp()
References: <1344355952-2382-1-git-send-email-bigeasy@linutronix.de> <1344355952-2382-4-git-send-email-bigeasy@linutronix.de> <50222D11.4010005@in.ibm.com> <502232DE.30702@linutronix.de>
In-Reply-To: <502232DE.30702@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12081005-3568-0000-0000-000002476E5A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2012 03:05 PM, Sebastian Andrzej Siewior wrote:
> On 08/08/2012 11:10 AM, Suzuki K. Poulose wrote:
>>> --- a/kernel/events/uprobes.c
>>> +++ b/kernel/events/uprobes.c
>>> @@ -1528,17 +1528,15 @@ cleanup_ret:
>>> utask->active_uprobe = NULL;
>>> utask->state = UTASK_RUNNING;
>>> }
>>> - if (uprobe) {
>>> - if (!(uprobe->flags & UPROBE_SKIP_SSTEP))
>>> + if (!(uprobe->flags & UPROBE_SKIP_SSTEP))
>>>
>> Shouldn't we check uprobe != NULL before we check the uprobe->flags ?
>> i.e, shouldn't the above line be :
>>
>> if (uprobe && ! (uprobe->flags & UPROBE_SKIP_SSTEP)) ?
>
> The function starts like this:
>
>           if (!uprobe) {
>                   if (is_swbp > 0) {
>                           send_sig(SIGTRAP, current, 0);
>                   } else {
>                           instruction_pointer_set(regs, bp_vaddr);
>                   }
>                   return;
>           }
>
> Which makes uprobe != NULL by the time we get there, no?
>
My bad, was looking at an older version of the function. Also,
the removal of the if (uprobe), check triggered the above question.

Thanks
Suzuki

