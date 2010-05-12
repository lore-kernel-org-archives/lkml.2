Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab0ELAip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 20:38:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12856 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754Ab0ELAio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 20:38:44 -0400
Message-ID: <4BE9F952.3060505@redhat.com>
Date: Tue, 11 May 2010 20:41:54 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH -tip 4/5] kprobes/x86: Use text_poke_smp_batch
References: <20100510175313.27396.34605.stgit@localhost6.localdomain6> <20100510175340.27396.7222.stgit@localhost6.localdomain6> <20100511144013.GA17656@Krystal>
In-Reply-To: <20100511144013.GA17656@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Masami Hiramatsu (mhiramat@redhat.com) wrote:
>> Use text_poke_smp_batch() in optimization path for reducing
>> the number of stop_machine() issues.
>>
>> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
>> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
>> Cc: Ingo Molnar <mingo@elte.hu>
>> Cc: Jim Keniston <jkenisto@us.ibm.com>
>> Cc: Jason Baron <jbaron@redhat.com>
>> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>> ---
>>
>>  arch/x86/kernel/kprobes.c |   37 ++++++++++++++++++++++++++++++-------
>>  include/linux/kprobes.h   |    2 +-
>>  kernel/kprobes.c          |   13 +------------
>>  3 files changed, 32 insertions(+), 20 deletions(-)
>>
>> diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
>> index 345a4b1..63a5c24 100644
>> --- a/arch/x86/kernel/kprobes.c
>> +++ b/arch/x86/kernel/kprobes.c
>> @@ -1385,10 +1385,14 @@ int __kprobes arch_prepare_optimized_kprobe(struct optimized_kprobe *op)
>>  	return 0;
>>  }
>>  
>> -/* Replace a breakpoint (int3) with a relative jump.  */
>> -int __kprobes arch_optimize_kprobe(struct optimized_kprobe *op)
>> +#define MAX_OPTIMIZE_PROBES 256
> 
> So what kind of interrupt latency does a 256-probes batch generate on the
> system ?  Are we talking about a few milliseconds, a few seconds ?

>From my experiment on kvm/4cpu, it took about 3 seconds in average.
With this patch, it went down to 30ms. (x100 faster :))

Thank you,
-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com

