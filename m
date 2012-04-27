Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761376Ab2D0Uar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 16:30:47 -0400
Received: from toast.topped-with-meat.com ([204.197.218.159]:43549 "EHLO
	topped-with-meat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760645Ab2D0Uan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 16:30:43 -0400
X-Greylist: delayed 638 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Apr 2012 16:30:43 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@hack.frob.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
X-Fcc: ~/Mail/lkml
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] TIF_NOTIFY_RESUME, arch/*/*/*signal*.c and all such
In-Reply-To: Al Viro's message of  Friday, 27 April 2012 19:45:29 +0100 <20120427184528.GL6871@ZenIV.linux.org.uk>
References: <CA+55aFxia+u3VAf0qN-2wv7DyAQZK-Z8=n=cqUvo--+C905aFg@mail.gmail.com>
	<20120420160848.GG6871@ZenIV.linux.org.uk>
	<20120420164239.GH6871@ZenIV.linux.org.uk>
	<CA+55aFzuTspDyyLaOA-g-dTWydaUeeWo9uVGR+rZ=ZJzPW_Ocw@mail.gmail.com>
	<20120420180748.GI6871@ZenIV.linux.org.uk>
	<20120423180150.GA6871@ZenIV.linux.org.uk>
	<20120424072617.GB6871@ZenIV.linux.org.uk>
	<20120426183742.GA324@redhat.com>
	<20120426231942.GJ6871@ZenIV.linux.org.uk>
	<20120427172444.GA30267@redhat.com>
	<20120427184528.GL6871@ZenIV.linux.org.uk>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20120427202002.8ED632C0BF@topped-with-meat.com>
Date: Fri, 27 Apr 2012 13:20:02 -0700 (PDT)
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.0 cv=e8d9udV/ c=1 sm=1 a=No4if-_LAocA:10
		a=Z6MIti7PxpgA:10 a=kj9zAlcOel0A:10 a=f5d7dizsgikjnF2V8KYA:9
		a=CjuIK1q_8ugA:10 a=WkljmVdYkabdwxfqvArNOQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 	BTW, I'm somewhat tempted to do the following: *ALL* calls of
> tracehook_signal_handler() are now immediately preceded by block_signals().
> Moreover, tracehook_signal_handler(...., 0) is currently a no-op, so
> it could be painlessly added after the remaining block_signals() instances.
> How about *folding* block_signals() (along with clear_restore_sigmask())
> into tracehook_signal_handler()?  I don't know if anyone has conflicting
> plans for that sucker; Roland?

I'm not actually doing much in the way of kernel work these days so I
certainly don't have any actual plans and it's pretty much all up to Oleg.
I'm also not really following this thread in detail, as I've dropped too
much context in the last year or two to be of a whole lot of help without
spending a lot of time recovering knowledge.  

But I will say that the intent of tracehook_signal_handler has always
been what its kerneldoc says: Call it once when handler setup is
complete (exactly once per signal delivery, so potentially multiple
times before actually returning to user mode).  Though it is indeed a
no-op today when stepping==0, we want its use to continue to conform
to that exact definition so that one day we could add e.g. a
PTRACE_EVENT_SIGNAL_HANDLED feature just by hacking tracehook.h and
not have to go back into every arch's signal code and recover
understanding of how the call is being used.  (It was more than enough
work to do that once when I broke out and documented the tracehook.h
interfaces the first time.)  You know, as if we thought modularity
were a useful notion.


Thanks,
Roland
