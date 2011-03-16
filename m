Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab1CPCsx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 22:48:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65292 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751856Ab1CPCsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 22:48:50 -0400
Message-ID: <4D802578.8050603@cn.fujitsu.com>
Date: Wed, 16 Mar 2011 10:50:32 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [PATCH V4 1/1] rcu: introduce kfree_rcu()
References: <4D7F356C.8020903@cn.fujitsu.com> <20110315113038.GB2167@linux.vnet.ibm.com>
In-Reply-To: <20110315113038.GB2167@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-16 10:47:28,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-16 10:47:29,
	Serialize complete at 2011-03-16 10:47:29
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2011 07:30 PM, Paul E. McKenney wrote:
> On Tue, Mar 15, 2011 at 05:46:20PM +0800, Lai Jiangshan wrote:
>> kfree_rcu() which was original proposed by Lai 2.5 years ago is one of
>> the most important RCU TODO list entries, Lai and Manfred have worked on
>> patches for this. This V4 patch is based on the Manfred's patch and
>> the V1 of Lai's patch. (These two patches are almost the same
>> in implementation, and this patch is mainly based on the Manfred's).
>>
>> Lai's V1 patch: http://lkml.org/lkml/2008/9/18/1
>> Manfred's patch: http://lkml.org/lkml/2009/1/2/115
>> RCU TODO list: http://www.kernel.org/pub/linux/kernel/people/paulmck/rcutodo.html
>>
>> This new introduced API kfree_rcu() primitive kfree()s the specified memory
>> after a RCU grace period elapses.
>>
>> It replaces many simple "call_rcu(head, simple_kfree_callback)";
>> These many simple_kfree_callback() instances just does
>>
>> 	kfree(containerof(head,struct whatever_struct,rcu_member));
>>
>> These simple_kfree_callback() instances are just duplicate code, we need
>> a generic function for them.
>>
>> And kfree_rcu() is also help for unloadable modules, kfree_rcu() does not
>> queue any function which belong to the module, so a rcu_barrier() can
>> be avoid when module exit. (If we queue any other function by call_rcu(),
>> rcu_barrier() is still needed.)
> 
> Thank you for putting this together!  It does represent a nice
> reduction in code size.
> 
> Once it settles out a bit, I intend to queue this patch.  It would be
> best if the subsystems queue their own patches using kfree_rcu() once
> this patch reaches mainline.
> 

It seems that the subsystems maintainers just Ack the patches.
I hope Ingo queue the Acked using kfree_rcu() patches into -tip,
it will help the kfree_rcu() reaches mainline earlier.

Thanks,
Lai
