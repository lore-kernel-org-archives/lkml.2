Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab1FGP4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 11:56:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:45754 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540Ab1FGP4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 11:56:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,333,1304319600"; 
   d="scan'208";a="10242119"
Message-ID: <4DEE4A32.2080501@linux.intel.com>
Date: Tue, 07 Jun 2011 08:56:34 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andy Lutomirski <luto@MIT.EDU>
CC: Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        David Oliver <david@rgmadvisors.com>, linux-kernel@vger.kernel.org,
        Shawn Bohrer <sbohrer@rgmadvisors.com>,
        Zachary Vonler <zvonler@rgmadvisors.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: Change in functionality of futex() system call.
References: <BANLkTinA9h=84gjYhus3EsNFL8tOUBe1jQ@mail.gmail.com>	 <1307373819.3098.40.camel@edumazet-laptop>	 <1307376672.2322.167.camel@twins>  <1307376989.2322.171.camel@twins>	 <1307377349.3098.65.camel@edumazet-laptop>	 <1307377782.2322.183.camel@twins>	 <1307378564.3098.67.camel@edumazet-laptop>	 <4DED1421.5000300@linux.intel.com> <1307383898.3098.90.camel@edumazet-laptop> <4DED976C.90009@linux.intel.com> <4DEE3944.5020005@mit.edu>
In-Reply-To: <4DEE3944.5020005@mit.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/07/2011 07:44 AM, Andy Lutomirski wrote:
> On 06/06/2011 11:13 PM, Darren Hart wrote:
>>
>>
>> On 06/06/2011 11:11 AM, Eric Dumazet wrote:
>>> Le lundi 06 juin 2011 à 10:53 -0700, Darren Hart a écrit :
>>>>
>>>
>>>> If I understand the problem correctly, RO private mapping really doesn't
>>>> make any sense and we should probably explicitly not support it, while
>>>> special casing the RO shared mapping in support of David's scenario.
>>>>
>>>
>>> We supported them in 2.6.18 kernels, apparently. This might sounds
>>> stupid but who knows ?
>>
>>
>> I guess this is actually the key point we need to agree on to provide a
>> solution. This particular case "worked" in 2.6.18 kernels, but that
>> doesn't necessarily mean it was supported, or even intentional.
>>
>> It sounds to me that we agree that we should support RO shared mappings.
>> The question remains about whether we should introduce deliberate
>> support of RO private mappings, and if so, if the forced COW approach is
>> appropriate or not.
>>
> 
> I disagree.
> 
> FUTEX_WAIT has side-effects.  Specifically, it eats one wakeup sent by 
> FUTEX_WAKE.  So if something uses futexes on a file mapping, then a 
> process with only read access could (if the semantics were changed) DoS 
> the other processes by spawning a bunch of threads and FUTEX_WAITing 
> from each of them.
> 
> If there were a FUTEX_WAIT_NOCONSUME that did not consume a wakeup and 
> worked on RO mappings, I would drop my objection.


This sounds like an argument for properly managing file permissions and
carefully selecting the mapping backing your futex word - but I don't
see this as compelling rationale to disable RO support entirely and
certainly not to add yet another futex op code.


-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
