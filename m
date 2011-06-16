Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915Ab1FPJgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 05:36:38 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:56340 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756441Ab1FPJgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 05:36:36 -0400
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 7bit
Date: Thu, 16 Jun 2011 11:36:32 +0200
From: Richard Weinberger <richard@nod.at>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>
Subject: Re: fs/exec.c: use BUILD_BUG_ON for VM_STACK_FLAGS &
 VM_STACK_INCOMPLETE_SETUP
In-Reply-To: <20110615215207.ba7a0386.akpm@linux-foundation.org>
References: <201106160359.p5G3x3j4020081@hera.kernel.org>
 <20110615213549.9b399976.randy.dunlap@oracle.com>
 <BANLkTimPwZsWNi=t57xz+h11gLn4CkOfug@mail.gmail.com>
 <20110615215207.ba7a0386.akpm@linux-foundation.org>
Message-ID: <c0f2919da04b0e601dc84ce31f1c9b81@radon2.swed.at>
User-Agent: RoundCube Webmail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jun 2011 21:52:07 -0700, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 15 Jun 2011 21:45:00 -0700 Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> 
>> On Wed, Jun 15, 2011 at 9:35 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> >
>> > fwiw, I just reported that this causes a build error in UML on x86_64
>> > in mmotm-2011-06-15:
>>
>> Gaah. That sounds really familiar. Have we done this same mistake once
>> before already, or is it just deja-vu for some other reason.
>>
>> On x86-64 UML, we have
>>
>>   #define VM_STACK_DEFAULT_FLAGS vm_stack_flags
>>
>> so VM_STACK_FLAGS ends up not being a constant, even though it really
>> looks like one.
>>
>> UML is _really_ confused in this area, btw. It seems to re-define that
>> thing if TIF_IA32 is defined. That's some crazy stuff. Doesn't the
>> compiler warn about it?
>>
>> I guess I should just revert that commit, though. Even if it does seem
>> to be the case that UML is just being crazy. Andrew?
>>
> 
> Sure, it was just a tiny optimization.
> 
> We can bring it back if Richard feels like decrazyifying UML ;)
> 

I'll look at this.
BTW: 64bit UML is really crazy. :P

Thanks,
//richard
