Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab2C3GQt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 02:16:49 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:30588 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391Ab2C3GQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 02:16:41 -0400
Message-ID: <4F754F2F.7000600@parallels.com>
Date: Fri, 30 Mar 2012 10:14:07 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Matt Helsley <matthltc@us.ibm.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        "spender@grsecurity.net" <spender@grsecurity.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, Darren Hart <dvhart@linux.intel.com>,
        "kernel-hardening@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Gene Cooperman <gene@ccs.neu.edu>
Subject: Re: [PATCH v2] futex: mark get_robust_list as deprecated
References: <20120323190855.GA27213@www.outflux.net> <m1fwczvuph.fsf@fess.ebiederm.org> <20120330050544.GA32299@count0.beaverton.ibm.com>
In-Reply-To: <20120330050544.GA32299@count0.beaverton.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2012 09:05 AM, Matt Helsley wrote:
> On Fri, Mar 23, 2012 at 03:06:02PM -0700, Eric W. Biederman wrote:
>> Kees Cook <keescook@chromium.org> writes:
>>
>>> Notify get_robust_list users that the syscall is going away.
>>
>> Has anyone asked the question if the folks working on checkpoint/restart
>> are going to need this.
>>
>> This seems like important information to know if you want to checkpoint
>> a process.
> 
> I have no idea if the CRIU and DMTCP folks care about this. I've added
> some folks related to those projects to the Cc list.

Nope, we don't need this syscall, thanks for notifying!

>>
>> Eric
>>
>>> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
>>> Signed-off-by: Kees Cook <keescook@chromium.org>
>>> ---
>>> v2:
>>>  - add note to feature-removal-schedule.txt.
>>> ---
>>>  Documentation/feature-removal-schedule.txt |   10 ++++++++++
>>>  kernel/futex.c                             |    2 ++
>>>  kernel/futex_compat.c                      |    2 ++
>>>  3 files changed, 14 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
>>> index 4bfd982..e3bf119 100644
>>> --- a/Documentation/feature-removal-schedule.txt
>>> +++ b/Documentation/feature-removal-schedule.txt
>>> @@ -543,3 +543,13 @@ When:	3.5
>>>  Why:	The old kmap_atomic() with two arguments is deprecated, we only
>>>  	keep it for backward compatibility for few cycles and then drop it.
>>>  Who:	Cong Wang <amwang@redhat.com>
>>> +
>>> +----------------------------
>>> +
>>> +What:	get_robust_list syscall
>>> +When:	2013
>>> +Why:	There appear to be no production users of the get_robust_list syscall,
>>> +	and it runs the risk of leaking address locations, allowing the bypass
>>> +	of ASLR. It was only ever intended for debugging, so it should be
>>> +	removed.
> 
> So I've looked in glibc, gdb, and DMTCP. The description of the intended
> use of get_robust_list() is accurate. However the benefit of ASLR is
> less clear when it comes to the robust list. In glibc the robust list is
> only used from NPTL. The robust list head is in struct pthread which can be
> obtained from pthread_self() anyway. Thus I think ASLR doesn't really help
> obfuscate the robust futex list unless the program is using robust futexes
> without the aid of glibc.
> 
> Cheers,
> 	-Matt Helsley
> 
> .
> 

