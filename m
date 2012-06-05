Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761293Ab2FEBX0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 21:23:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:15985 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757358Ab2FEBXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 21:23:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="148244921"
Message-ID: <4FCD5F88.6050502@linux.intel.com>
Date: Mon, 04 Jun 2012 18:23:20 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
        H Peter Anvin <hpa@zytor.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/6] x86/cpu hotplug: Wake up offline CPU via mwait or
 nmi
References: <1338833876-29721-1-git-send-email-fenghua.yu@intel.com> <alpine.LFD.2.02.1206042203590.3086@ionos> <1338842001.28282.135.camel@twins> <87zk8iioam.fsf@rustcorp.com.au>
In-Reply-To: <87zk8iioam.fsf@rustcorp.com.au>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/4/2012 5:40 PM, Rusty Russell wrote:
> On Mon, 04 Jun 2012 22:33:21 +0200, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Mon, 2012-06-04 at 22:11 +0200, Thomas Gleixner wrote:
>>
>>> I understand what you are trying to do, though I completely disagree
>>> with the solution.
>>>
>>> The main problem of the current hotplug code is that it is an all or
>>> nothing approach. You have to tear down the whole thing completely
>>> instead of just taking it out of the usable set of cpus.
>>>
>>> I'm working on a proper state machine driven online/offline sequence,
>>> where you can put the cpu into an intermediate state which avoids
>>> bringing it down completely. This is enough to get the full
>>> powersaving benefits w/o having to go through all the synchronization
>>> states of a full online/offline. That will shorten the onlining time
>>> of an previously offlined cpu to almost nothing.
>>>
>>> I really want to avoid adding more bandaids to the hotplug code before
>>> we have sorted out the existing horror.
>>
>> Its far worse.. you shouldn't _ever_ care about hotplug latency unless
>> you've got absolutely braindead hardware. We all now ARM has been
>> particularly creative here, but is Intel now trying to trump ARM at
>> stupid?
> 
> I disagree.  Deactivating a cpu for power saving is halfway to hotplug
> anyway.  I'd rather unify the two cases, where we can specify how dead a
> CPU should be, than have individual archs and boards do random hacks.

well on PC's there really is no difference at least;
idle equals "all power removed" already there.

but I can see that on some other architectures, that lack idle that
deep, there can be a real difference.

