Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357Ab2LRFLc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 00:11:32 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:37449 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab2LRFLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 00:11:31 -0500
Message-ID: <50CFFAF7.6070406@in.ibm.com>
Date: Tue, 18 Dec 2012 10:41:19 +0530
From: "Suzuki K. Poulose" <suzuki@in.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: bigeasy@linutronix.de, ananth@in.ibm.com, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, benh@kernel.crashing.org, mingo@elte.hu,
        anton@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] uprobes/powerpc: Make use of generic routines
 to enable single step
References: <20121203150438.7727.74924.stgit@suzukikp> <20121203150946.7727.82735.stgit@suzukikp> <20121214200241.GA27195@redhat.com>
In-Reply-To: <20121214200241.GA27195@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121805-8256-0000-0000-0000057B6367
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2012 01:32 AM, Oleg Nesterov wrote:
> On 12/03, Suzuki K. Poulose wrote:
>>
>> Replace the ptrace helpers with the powerpc generic routines to
>> enable/disable single step. We save/restore the MSR (and DCBR for BookE)
>> across for the operation. We don't have to disable the single step,
>> as restoring the MSR/DBCR would restore the previous state.
>
> Obviously I can't review this series (although it looks fine to me).
>
> Just one note,
>
>> @@ -121,7 +132,7 @@ int arch_uprobe_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
>>
>>   	WARN_ON_ONCE(current->thread.trap_nr != UPROBE_TRAP_NR);
>>
>> -	uprobe_restore_context_sstep(&utask->autask);
>> +	uprobe_restore_context_sstep(&utask->autask, regs);
>
> I am not sure ppc needs this, but note that x86 does a bit more.
>
> Not only we need to restore the "single-step" state, we need to
> send SIGTRAP if it was not set by us. The same for _skip_sstep.
>
Ok. I will investigate that part and do the necessary.

Thanks
Suzuki

