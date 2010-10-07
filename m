Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594Ab0JGVYx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 17:24:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17728 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181Ab0JGVYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 17:24:51 -0400
Subject: Re: Linux 2.6.36-rc7
From: Eric Paris <eparis@redhat.com>
To: John Stoffel <john@stoffel.org>
Cc: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        agruen@suse.de
In-Reply-To: <19630.13234.840343.153381@quad.stoffel.home>
References: <AANLkTi=LsBNU+O2hqZUcM2nYM_ze6qPq3thwSZBMtY_v@mail.gmail.com>
	 <201010071710.46938.tvrtko.ursulin@sophos.com>
	 <201010071815.54303.tvrtko.ursulin@sophos.com>
	 <1286472835.2656.15.camel@dhcp231-98.rdu.redhat.com>
	 <19630.13234.840343.153381@quad.stoffel.home>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 17:24:34 -0400
Message-ID: <1286486674.2571.16.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-07 at 16:55 -0400, John Stoffel wrote:

> So what happens when you try to register a priority level and someone
> else has already gotten that level?  Does the call fail?  Do you get
> bumped down to the next open level?  Can you *tell* what level you're
> at and whether or not some other decision maker is ahead of you? 

Well it hasn't been discussed and implemented so I can't answer that.
*smile*

I will tell you that the way I envision it working (and being backwards
compatible) is that priority 0 is the last thing to be serviced.  If 2
things register at the same priority the order between them getting
events is unpredictable.  So when an HSM uses the interface it would use
the highest priority.  An AV vendor might use (highest priority / 2)
while normal inotify like listeners would all be happy using priority 0.

> But I'd really like some docs in the next release which tells me as a
> poor dumb sysadmin how it can and should be used and what the gotchas
> are.

We have example man-like pages in the commit logs which I expected to be
used as the basis for man pages once the interface was accepted.  They
aren't perfect but they are

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=52c923dd079df49f58016a9e56df184b132611d6
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=2a3edf86040a7e15684525a2aadc29f532c51325

You'll also find an example program which shows all of the features at

http://git.kernel.org/?p=linux/kernel/git/agruen/fanotify-example.git;a=summary

I don't think digging around in kernel code is the right way   :)

-Eric

