Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab0FWKU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 06:20:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61310 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751161Ab0FWKUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 06:20:25 -0400
Message-ID: <4C21DFDD.9030107@cn.fujitsu.com>
Date: Wed, 23 Jun 2010 18:20:13 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] percpu: add percpu_variable_ptr()
References: <4C21DC33.6070404@cn.fujitsu.com> <4C21DCFF.5050604@kernel.org>
In-Reply-To: <4C21DCFF.5050604@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> On 06/23/2010 12:04 PM, Lai Jiangshan wrote:
>> The percpu variable and allocated percpu data are compatible
>> witch each other, This patch adds a API, thus we can use
>> per_cpu_ptr() for defined/declared percpu variable.
>>
>> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
>> ---
>> diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
>> index ce2dc65..d5c8d7f 100644
>> --- a/include/linux/percpu-defs.h
>> +++ b/include/linux/percpu-defs.h
>> @@ -81,6 +81,12 @@
>>  #endif
>>  
>>  /*
>> + * Ptr of the declared/defined per-CPU variable.
>> + * It is totally compatible with the return from alloc_percpu().
>> + */
>> +#define percpu_variable_ptr(name) (&(name))
> 
> Why not just use &name?
> 

I remember the real variable name is hidden.
We can't expose the inner details of percpu, so I add a macro for it.

Thanks,
Lai
