Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab1FFR4P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 13:56:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:64500 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607Ab1FFR4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 13:56:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,327,1304319600"; 
   d="scan'208";a="9777295"
Message-ID: <4DED14BD.9000706@linux.intel.com>
Date: Mon, 06 Jun 2011 10:56:13 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        David Oliver <david@rgmadvisors.com>, linux-kernel@vger.kernel.org,
        Shawn Bohrer <sbohrer@rgmadvisors.com>,
        Zachary Vonler <zvonler@rgmadvisors.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: Change in functionality of futex() system call.
References: <BANLkTinA9h=84gjYhus3EsNFL8tOUBe1jQ@mail.gmail.com> <1307373819.3098.40.camel@edumazet-laptop> <1307376672.2322.167.camel@twins> <1307376989.2322.171.camel@twins> <1307377349.3098.65.camel@edumazet-laptop> <1307377782.2322.183.camel@twins> <1307378564.3098.67.camel@edumazet-laptop> <1307379926.2322.219.camel@twins> <1307380297.3098.74.camel@edumazet-laptop> <20110606172707.GB27245@home.goodmis.org>
In-Reply-To: <20110606172707.GB27245@home.goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/06/2011 10:27 AM, Steven Rostedt wrote:
> On Mon, Jun 06, 2011 at 07:11:37PM +0200, Eric Dumazet wrote:
>> Le lundi 06 juin 2011 à 19:05 +0200, Peter Zijlstra a écrit :
>>
>>> Dunno, using futexes on private file maps is stupid imo, its just asking
>>> for trouble, ro private file maps are even worse. Forcing the COW is the
>>> only sane answer in that it gives consistent results and 'breaks' silly
>>> expectations early instead of sometimes.
>>>
>>> Anyway, that's not really the issue here, as David uses MAP_SHARED (as
>>> one should if one is interested in the shared value).
>>
>> Sure, but maybe another guy is 'stupid' and uses MAP_PRIVATE on its
>> read-only mappings. With old kernels this was working, and we were not
>> doing the COW.
> 
> That sounds like a bug in both the kernel and userspace. I would expect
> a MAP_PRIVATE not be seen by any other process regardless. That's the
> definition of PRIVATE.
> 
>  From: http://www.gnu.org/s/hello/manual/libc/Memory_002dmapped-I_002fO.html
> 
> MAP_PRIVATE
>     This specifies that writes to the region should never be written back
>     to the attached file. Instead, a copy is made for the process, and the
>     region will be swapped normally if memory runs low. No other process
>     will see the changes. 


This doesn't address what happens if changes to a MAP_SHARED mapping are
visible to a MAP_PRIVATE mapping, which is more the issue at hand I believe.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
