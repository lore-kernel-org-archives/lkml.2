Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab0ELGPZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 02:15:25 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56118 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751044Ab0ELGPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 02:15:22 -0400
Message-ID: <4BEA47CA.2020508@cn.fujitsu.com>
Date: Wed, 12 May 2010 14:16:42 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Rientjes <rientjes@google.com>, Nick Piggin <npiggin@suse.de>,
       Paul Menage <menage@google.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH 2/2] cpuset,mm: fix no node to alloc memory when changing
 cpuset's mems
References: <4BDFFCCA.3020906@cn.fujitsu.com> <20100511184900.8211b6f9.akpm@linux-foundation.org>
In-Reply-To: <20100511184900.8211b6f9.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 2010-5-12 9:49, Andrew Morton wrote:
...
>> --- a/kernel/exit.c
>> +++ b/kernel/exit.c
>> @@ -16,6 +16,7 @@
>>  #include <linux/key.h>
>>  #include <linux/security.h>
>>  #include <linux/cpu.h>
>> +#include <linux/cpuset.h>
>>  #include <linux/acct.h>
>>  #include <linux/tsacct_kern.h>
>>  #include <linux/file.h>
>> @@ -1003,8 +1004,10 @@ NORET_TYPE void do_exit(long code)
>>  
>>  	exit_notify(tsk, group_dead);
>>  #ifdef CONFIG_NUMA
>> +	task_lock(tsk);
>>  	mpol_put(tsk->mempolicy);
>>  	tsk->mempolicy = NULL;
>> +	task_unlock(tsk);
>>  #endif
>>  #ifdef CONFIG_FUTEX
>>  	if (unlikely(current->pi_state_cache))
> 
> Given that this function is already holding task_lock(tsk), this
> didn't work very well.

Sorry for replying late.

Thanks for your patch that removes task_lock(tsk).

I made this patch against the mainline tree, and do_exit() in the mainline tree
doesn't hold task_lock(tsk), so I took task_lock(tsk). But I didn't take notice
that do_exit() in the mmotm tree had been changed, and I made this mistake.

> Also, why was the inclusion of cpuset.h added?  Nothing which this
> patch adds appears to need it?
> 

This is my mistake, I will make patch to cleanup it.

Thanks!
Miao 

