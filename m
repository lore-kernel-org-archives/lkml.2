Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758695Ab0JHPnI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 11:43:08 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:59963 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab0JHPnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 11:43:06 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19631.15310.568446.991954@quad.stoffel.home>
Date: Fri, 8 Oct 2010 11:42:06 -0400
From: "John Stoffel" <john@stoffel.org>
To: Eric Paris <eparis@redhat.com>
Cc: John Stoffel <john@stoffel.org>,
        Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        agruen@suse.de
Subject: Re: Linux 2.6.36-rc7
In-Reply-To: <1286486674.2571.16.camel@localhost.localdomain>
References: <AANLkTi=LsBNU+O2hqZUcM2nYM_ze6qPq3thwSZBMtY_v@mail.gmail.com>
	<201010071710.46938.tvrtko.ursulin@sophos.com>
	<201010071815.54303.tvrtko.ursulin@sophos.com>
	<1286472835.2656.15.camel@dhcp231-98.rdu.redhat.com>
	<19630.13234.840343.153381@quad.stoffel.home>
	<1286486674.2571.16.camel@localhost.localdomain>
X-Mailer: VM 8.1.1 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Eric" == Eric Paris <eparis@redhat.com> writes:

Eric> On Thu, 2010-10-07 at 16:55 -0400, John Stoffel wrote:
>> So what happens when you try to register a priority level and someone
>> else has already gotten that level?  Does the call fail?  Do you get
>> bumped down to the next open level?  Can you *tell* what level you're
>> at and whether or not some other decision maker is ahead of you? 

Eric> Well it hasn't been discussed and implemented so I can't answer that.
Eric> *smile*

Ah, but you have implemented multiple notifiers registered at the same
time, without priorities, right?  So that's just the degenerate case
which I assume is handled already.

Eric> I will tell you that the way I envision it working (and being
Eric> backwards compatible) is that priority 0 is the last thing to be
Eric> serviced.  If 2 things register at the same priority the order
Eric> between them getting events is unpredictable.  So when an HSM
Eric> uses the interface it would use the highest priority.  An AV
Eric> vendor might use (highest priority / 2) while normal inotify
Eric> like listeners would all be happy using priority 0.

Ugh, I'd prefer that priority 0 is first (highest), but I can see how
that would make ABI problems, assuming we don't punt on releasing the
ABI now.  

So if the order is undefined now, that's not good.  Well... maybe it's
acceptable, but I can see all kinds of problems cropping up.
Hopefully they're processed in order of notifier creation instead.  So
if I insert a notifier, anyone who inserts a notifier after me gets
serviced after my notifier gets run.  That would seem to be the
logical and sane semantics to use here.

Again, I'm really approaching this as a SysAdmin who'd love to use
this in an HSM environment, so ordering is a *key* requirement.

Which is why I'm going to harp of the documentation in the Kernel from
day one too.  

>> But I'd really like some docs in the next release which tells me as a
>> poor dumb sysadmin how it can and should be used and what the gotchas
>> are.

Eric> We have example man-like pages in the commit logs which I expected to be
Eric> used as the basis for man pages once the interface was accepted.  They
Eric> aren't perfect but they are

Eric> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=52c923dd079df49f58016a9e56df184b132611d6
Eric> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=2a3edf86040a7e15684525a2aadc29f532c51325

Eric> You'll also find an example program which shows all of the
Eric> features at

Eric> http://git.kernel.org/?p=linux/kernel/git/agruen/fanotify-example.git;a=summary

Eric> I don't think digging around in kernel code is the right way   :)

Sure, but putting some design documentation which explains how it's
expected to be used, with pointers to the canonical site holding docs
and such *is* expected.  Just see the docs for inotify and such.  

Thanks for the pointers, I'll try to find the time to look them over
and make some more comments.

John
