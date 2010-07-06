Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab0GFC07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 22:26:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754328Ab0GFC05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 22:26:57 -0400
Message-ID: <4C329450.2010703@redhat.com>
Date: Tue, 06 Jul 2010 10:26:24 +0800
From: Xiaotian Feng <dfeng@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Ali Gholami Rudi <ali@rudi.ir>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       x86@kernel.org, venki@google.com, tglx@linutronix.de,
       suresh.b.siddha@intel.com, mingo@redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [regression] commit 6a4f3b52 causes invalid memtype
References: <20100507075128@tarekhel> <4C319D61.5090002@redhat.com> <20100507092842@tarekhel> <4C31A7A0.1020800@redhat.com> <4c31ac7b.J+CU0Yt+zKZ9ho1fjKvu6Z1v@tarekhel>	<20100705104035.GA28190@elte.hu> <20100507113814@tarekhel>
In-Reply-To: <20100507113814@tarekhel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2010 07:38 PM, Ali Gholami Rudi wrote:
> Ingo Molnar<mingo@elte.hu>  wrote:
>>>>>> commit 2463eb8b3093995e09a0d41b3d78ee0cf5fb4249
>>>>>> Author: Peter Zijlstra<peterz@infradead.org>
>>>>>> Date:   Sat May 29 15:31:43 2010 +0200
>>>>>>
>>>>>>        rbtree: Undo augmented trees performance damage
>>>>>
>>>>> Where can I get it?  I couldn't find it either in
>>>>> Linus' or x86 repo tip.
>>>> http://git.kernel.org/tip/2463eb8b3093995e09a0d41b3d78ee0cf5fb4249
>>>
>>> It does fix it.
>>
>> Hm, interesting. That's a pure performance fix - so why does it fix a
>> regression?
>>
>> Does Peter's augmented rbtrees improvements fix a bug too, as a side-effect?
>> If yes then we need to accelerate that commit - right now it's aimed for
>> v2.6.36.
>
> Since the bug appears after commit 6a4f3b52, it seems to be
> related to the value of memtype->subtree_max_end.  Peter's
> patch seems to change the way memtype->subtree_max_end is
> updated, which seems to fix the problem too.

Actually, this exposed a bug in augmented rbtree 
(http://lkml.org/lkml/2010/6/21/459).
With commit 6a4f3b52, the bug was easier to trigger :-)

>
> Thanks,
> Ali
>
>

