Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758287Ab0DAQhj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:37:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758036Ab0DAQdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:33:44 -0400
Message-ID: <4BB487D5.7010803@redhat.com>
Date: Thu, 01 Apr 2010 14:47:33 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, aarcange@redhat.com,
       akpm@linux-foundation.org, Kent Overstreet <kent.overstreet@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [COUNTERPATCH] mm: avoid overflowing preempt_count() in mmu_take_all_locks()
References: <1270117906.1653.139.camel@laptop>	 <alpine.LFD.2.00.1004011300550.32352@localhost.localdomain>	 <4BB47FC3.1020606@redhat.com>  <4BB480CC.2060503@redhat.com>	 <1270121264.1653.205.camel@laptop> <1270122194.1653.223.camel@laptop>
In-Reply-To: <1270122194.1653.223.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2010 02:43 PM, Peter Zijlstra wrote:
> On Thu, 2010-04-01 at 13:27 +0200, Peter Zijlstra wrote:
>    
>> I've almost got a patch done that converts those two, still need to look
>> where that tasklist_lock muck happens.
>>      
> OK, so the below builds and boots, only need to track down that
> tasklist_lock nesting, but I got to run an errand first.
>
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -327,7 +327,7 @@ static void drop_anon_vma(struct rmap_item *rmap_item)
>
>   	if (atomic_dec_and_lock(&anon_vma->ksm_refcount,&anon_vma->lock)) {
>   		int empty = list_empty(&anon_vma->head);
> -		spin_unlock(&anon_vma->lock);
> +		mutex_unlock(&anon_vma->lock);
>   		if (empty)
>   			anon_vma_free(anon_vma);
>   	}
>    

You need to convert the atomic_dec_and_lock() as well.


-- 
error compiling committee.c: too many arguments to function

