Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996Ab2LCPsi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 10:48:38 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:33774 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648Ab2LCPsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 10:48:37 -0500
Message-ID: <50BCC9C7.8090609@in.ibm.com>
Date: Mon, 03 Dec 2012 21:18:23 +0530
From: "Suzuki K. Poulose" <suzuki@in.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: ananth@in.ibm.com
CC: bigeasy@linutronix.de, oleg@redhat.com, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, benh@kernel.crashing.org, mingo@elte.hu,
        anton@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] uprobes/powerpc: Introduce routines for save/restore
 context
References: <20121203150438.7727.74924.stgit@suzukikp> <20121203150849.7727.53296.stgit@suzukikp> <20121203151544.GB6333@in.ibm.com>
In-Reply-To: <20121203151544.GB6333@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120315-3568-0000-0000-000002DC1374
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2012 08:45 PM, Ananth N Mavinakayanahalli wrote:
> On Mon, Dec 03, 2012 at 08:39:35PM +0530, Suzuki K. Poulose wrote:
>> From: Suzuki K. Poulose <suzuki@in.ibm.com>
>>
>> Introduce routines for saving and restoring the context
>> befre/after the single step. No functional changes involved.
>>
>> These will be extended later to save/restore more info about
>> the process once we replace the ptrace helpers.
>>
>> Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
>> ---
>>   arch/powerpc/kernel/uprobes.c |   16 +++++++++++++---
>>   1 file changed, 13 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/powerpc/kernel/uprobes.c b/arch/powerpc/kernel/uprobes.c
>> index bc77834..1a62353 100644
>> --- a/arch/powerpc/kernel/uprobes.c
>> +++ b/arch/powerpc/kernel/uprobes.c
>> @@ -52,6 +52,16 @@ int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe,
>>   	return 0;
>>   }
>>
>> +static void uprobe_save_context_sstep(struct arch_uprobe_task *autask)
>> +{
>> +	autask->saved_trap_nr = current->thread.trap_nr;
>> +}
>> +
>> +static void uprobe_restore_context_sstep(struct arch_uprobe_task *autask)
>> +{
>> +	current->thread.trap_nr = autask->saved_trap_nr;
>> +}
>
> Can't the two above be inline?
I had this discussion with Srikar and he was of the opinion that, we
should leave it as just static and let the compiler do the optimization.


Thanks
Suzuki

