Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675Ab2HZCJv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 22:09:51 -0400
Received: from mx2.parallels.com ([64.131.90.16]:50582 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754737Ab2HZCJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 22:09:49 -0400
Message-ID: <503984AB.6030802@parallels.com>
Date: Sat, 25 Aug 2012 22:06:35 -0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [PATCH v2] fork: fix oops after fork failure
References: <1345736168-1990-1-git-send-email-glommer@parallels.com> <20120824150804.8e3c4b7e.akpm@linux-foundation.org>
In-Reply-To: <20120824150804.8e3c4b7e.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [32.167.60.109]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2012 06:08 PM, Andrew Morton wrote:
> On Thu, 23 Aug 2012 19:36:08 +0400
> Glauber Costa <glommer@parallels.com> wrote:
> 
>> When we want to duplicate a new process, dup_task_struct() will undergo
>> a series of allocations. If alloc_thread_info_node() fails, we call
>> free_task_struct() and return.
>>
>> This seems right, but it is not. free_task_struct() will not only free
>> the task struct from the kmem_cache, but will also call
>> arch_release_task_struct(). The problem is that this function is
>> supposed to undo whatever arch-specific work done by
>> arch_dup_task_struct(), that is not yet called at this point.  The
>> particular problem I ran accross was that in x86, we will arrive at
>> fpu_free() without having ever allocated it.
> 
> I think ths was already fixed by f19b9f74b7ea3b ("fork: fix error
> handling in dup_task()").  As you would have noticed if you were
> preparing patches against up-to-date kernel versions!
> 
I am basing all my patches against mmotm (actually, Michal's git copy of
it...)
I might have missed one spin, though. It happens
