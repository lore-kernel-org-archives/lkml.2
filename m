Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005Ab2K0E4s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 23:56:48 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:46468 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab2K0E4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 23:56:47 -0500
Message-ID: <50B44808.3000704@in.ibm.com>
Date: Tue, 27 Nov 2012 10:26:40 +0530
From: "Suzuki K. Poulose" <suzuki@in.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: bigeasy@linutronix.de, ananth@in.ibm.com, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, benh@kernel.crashing.org, mingo@elte.hu,
        anton@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] uprobes/powerpc: Make use of generic routines to
 enable single step
References: <20121126110007.6545.43875.stgit@suzukikp.in.ibm.com> <20121126110548.6545.53281.stgit@suzukikp.in.ibm.com> <20121126170135.GA8668@redhat.com>
In-Reply-To: <20121126170135.GA8668@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12112704-5816-0000-0000-0000058F8844
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2012 10:31 PM, Oleg Nesterov wrote:
> On 11/26, Suzuki K. Poulose wrote:
>>
>> @@ -121,8 +125,11 @@ int arch_uprobe_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
>>   	 * to be executed.
>>   	 */
>>   	regs->nip = utask->vaddr + MAX_UINSN_BYTES;
>> +	regs->msr = utask->autask.saved_msr;
>> +#ifdef CONFIG_PPC_ADV_DEBUG_REGS
>> +	mtspr(SPRN_DBCR0, utask->autask.saved_dbcr);
>> +#endif
>>
>> -	user_disable_single_step(current);
>
> Don't we need the same change in arch_uprobe_abort_xol() ?
Yes, we do. Thanks for catching that. I will fix it.

Thanks for the review.

Suzuki

