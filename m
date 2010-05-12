Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab0ELI71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 04:59:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58995 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753899Ab0ELI7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 04:59:25 -0400
Message-ID: <4BEA6E3D.10503@cn.fujitsu.com>
Date: Wed, 12 May 2010 17:00:45 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Rientjes <rientjes@google.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Paul Menage <menage@google.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH -mm] cpuset,mm: fix no node to alloc memory when changing
 cpuset's mems - fix2
References: <4BEA56D3.6040705@cn.fujitsu.com> <20100512003246.9f0ee03c.akpm@linux-foundation.org>
In-Reply-To: <20100512003246.9f0ee03c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 2010-5-12 12:32, Andrew Morton wrote:
> On Wed, 12 May 2010 15:20:51 +0800 Miao Xie <miaox@cn.fujitsu.com> wrote:
> 
>> @@ -985,6 +984,7 @@ repeat:
>>  	 * for the read-side.
>>  	 */
>>  	while (ACCESS_ONCE(tsk->mems_allowed_change_disable)) {
>> +		task_unlock(tsk);
>>  		if (!task_curr(tsk))
>>  			yield();
>>  		goto repeat;
> 
> Oh, I meant to mention that.  No yield()s, please.  Their duration is
> highly unpredictable.  Can we do something more deterministic here?

Maybe we can use wait_for_completion().

> 
> Did you consider doing all this with locking?  get_mems_allowed() does
> mutex_lock(current->lock)?

do you means using a real lock(such as: mutex) to protect mempolicy and mem_allowed?

It may cause the performance regression, so I do my best to abstain from using a real
lock.

Thanks
Miao

> 
> 
> 
> 


