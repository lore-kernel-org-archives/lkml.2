Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031Ab1FFRxl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 13:53:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:30175 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572Ab1FFRxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 13:53:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,327,1304319600"; 
   d="scan'208";a="9776682"
Message-ID: <4DED1421.5000300@linux.intel.com>
Date: Mon, 06 Jun 2011 10:53:37 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        David Oliver <david@rgmadvisors.com>, linux-kernel@vger.kernel.org,
        Shawn Bohrer <sbohrer@rgmadvisors.com>,
        Zachary Vonler <zvonler@rgmadvisors.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: Change in functionality of futex() system call.
References: <BANLkTinA9h=84gjYhus3EsNFL8tOUBe1jQ@mail.gmail.com>	 <1307373819.3098.40.camel@edumazet-laptop>	 <1307376672.2322.167.camel@twins>  <1307376989.2322.171.camel@twins>	 <1307377349.3098.65.camel@edumazet-laptop>	 <1307377782.2322.183.camel@twins> <1307378564.3098.67.camel@edumazet-laptop>
In-Reply-To: <1307378564.3098.67.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/06/2011 09:42 AM, Eric Dumazet wrote:
> Le lundi 06 juin 2011 à 18:29 +0200, Peter Zijlstra a écrit :
>> On Mon, 2011-06-06 at 18:22 +0200, Eric Dumazet wrote:
>>> Le lundi 06 juin 2011 à 18:16 +0200, Peter Zijlstra a écrit :
>>>
>>>> Hmm, wouldn't that still be susceptible to the zero-page thing if: we
>>>> create a writable private file map of a sparse file, touch a page and
>>>> then remap the thing RO?
>>>>
>>>>
>>>>
>>>
>>> Also I am not sure how MAP_PRIVATE could be affected. If we still try a
>>> RW gup()... It will allocate a page for us, instead of still pointing to
>>> shared one.
>>>
>>> On previous kernel, the application using read-only mapping could use
>>> MAP_PRIVATE or MAP_SHARED with same 'behavior'
>>
>> But by not forcing the COW you get different behaviour depending on when
>> you call FUTEX_WAIT, surely that's not correct either?
> 
> 
> As long as the current process never writes to the page holding the
> futex, the page stay shared. Behavior should be same with PRIVATE or
> SHARED ?

If I understand the problem correctly, RO private mapping really doesn't
make any sense and we should probably explicitly not support it, while
special casing the RO shared mapping in support of David's scenario.

> 
> In David Oliver case, this is needed : He wants to catch a change in a
> file/memory region written by another process.

But with shared mapping and shared futexes. He just needs the ability to
FUTEX_WAIT on a RO mapping. Or is that what you were saying?

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
