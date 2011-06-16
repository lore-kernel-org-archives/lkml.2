Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab1FPCkM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 22:40:12 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60716 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752594Ab1FPCkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 22:40:10 -0400
Message-ID: <4DF96D10.60904@cn.fujitsu.com>
Date: Thu, 16 Jun 2011 10:40:16 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, josh@joshtriplett.org,
        Manfred Spraul <manfred@colorfullife.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu,doc: lock-free update site
References: <4DF7231B.1080708@cn.fujitsu.com> <BLU0-SMTP15CB1FCA05185652974DF796680@phx.gbl>
In-Reply-To: <BLU0-SMTP15CB1FCA05185652974DF796680@phx.gbl>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-16 10:39:42,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-16 10:39:44,
	Serialize complete at 2011-06-16 10:39:44
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2011 08:50 PM, Mathieu Desnoyers wrote:
> * Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
>> Add a document which describes a pattern of using RCU to implement lock-free(lockless)
>> update site.
>>
> [...]
>> @@ -0,0 +1,143 @@
>> +Lock-free(lockless) update site
>> +
>> +This article describes a pattern of using RCU to implement lock-free(lockless)
>> +update site. RCU update site is considered call-rare and it is protected
>> +by a update-site lock generally. But blocking algorithms are undesirable
>> +in some cases for some reasons, thus, this pattern may help.
> 
> Hi Lai,
> 
> Yes, using this kind of rcu read-side lock to protect against the
> cmpxchg ABA problem is well-known (to me at least) ;) I used this
> technique in the userspace RCU library "lock-free queue" and "lock-free
> stack" in 2010*. Please feel free to dig through my RCU data containers code
> to bring in more data structure examples:
> 
> http://git.lttng.org/?p=userspace-rcu.git;a=blob;f=urcu/static/rculfqueue.h;h=b627e450cfdd581692b474d89437e3fd47f18463;hb=HEAD
> 
> http://git.lttng.org/?p=userspace-rcu.git;a=blob;f=urcu/static/rculfqueue.h;h=b627e450cfdd581692b474d89437e3fd47f18463;hb=HEAD
> 
> Thanks!
> 
> Mathieu


Hi, Mathieu

I will try to make simple update site wait-free, so I wrote a simple guide/document
at first. I didn't notice your work. Your work is excellent,
I will add some references. I hope you rewrite/pretty this document also.

The lock-free stack is a good example, but the lock-free queue is not good here I think.

Thanks,
Lai


> 
> * AFAIK I introduced this technique using RCU read-side C.S. to deal
>   with cmpxchg ABA at that point, but someone might have thought about
>   it before me without my knowledge. My litterature survey so far
>   indicates that using a double-word CAS on a pointer/counter was one of
>   the usual technique used to protect against cmpxchg ABA so far. Other
>   techniques imply allocating elements in a limited-size array (so a
>   simple cmpxchg can update the array index and counter atomically),
>   Hasard Pointers, or having a full-blown GC which provides similar
>   guarantees to the RCU grace period with a read-side lock held.
>   Ref.:
> 
>   [1998] Maged Michael, Michael Scott "Simple, fast, and practical non-blocking and blocking concurrent queue algorithms"
>   [2002] Maged M.Michael "Safe memory reclamation for dynamic lock-free objects using atomic reads and writes"
>   [2003] Maged M.Michael "Hazard Pointers: Safe memory reclamation for lock-free objects"
> 

