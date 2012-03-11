Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836Ab2CKTpA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 15:45:00 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40798 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab2CKTox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 15:44:53 -0400
Message-ID: <4F5D00AE.8000602@openvz.org>
Date: Sun, 11 Mar 2012 23:44:46 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Firefox/10.0.2 Iceape/2.7.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH bisected regression] sched: rebuild sched domains at suspend/resume
References: <20120306204357.13169.90791.stgit@zurg> <1331067743.11248.333.camel@twins> <CA+55aFxPiW=T8iNy=Fb_fuO2DYV9+sQL-mr8=Uc7cWymTyVt6A@mail.gmail.com> <1331084302.11248.338.camel@twins> <CA+55aFx6NXjLpAz_Bu1wvaxFB-2zrYGkfBeN_8rM5q7MkYuNEQ@mail.gmail.com>
In-Reply-To: <CA+55aFx6NXjLpAz_Bu1wvaxFB-2zrYGkfBeN_8rM5q7MkYuNEQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Tue, Mar 6, 2012 at 5:38 PM, Peter Zijlstra<a.p.zijlstra@chello.nl>  wrote:
>> On Tue, 2012-03-06 at 16:54 -0800, Linus Torvalds wrote:
>>> I do agree that reverting is probably safer at this point, but can we
>>> get agreement on this?
>>
>> I agree with reverting, shoot it in the head :-) Do you want a git
>> thingy?
>
> Well, it's less a "git thingy" and more that there are tons of people
> involved with the original commit that haven't even piped up.
>
> Srivatsa, Ingo, Prashanth..
>
> In fact, I notice that Prashanth doesn't even seem to have been cc'd,
> even if he's the original reporter of the commit that gets reverted.
> Added (see lkml)

I forget to mention my kernel boot options. I live with them for a while, so I just forget about it.
"debug threadirqs i915.i915_enable_rc6=1 i915.i915_enable_fbc=1 i915.lvds_downclock=1 crashkernel=128M"

So, "threadirqs" is a lost piece of the puzzle -- without it I cannot reproduce the bug.
However, I have no idea how this is connected to sched-domains. =)

(Add Thomas Gleixner to CC)
