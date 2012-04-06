Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393Ab2DFEpp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 00:45:45 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:48726 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937Ab2DFEpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 00:45:44 -0400
Message-ID: <4F7E74F4.90604@msgid.tls.msk.ru>
Date: Fri, 06 Apr 2012 08:45:40 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120216 Icedove/8.0
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: dramatic I/O slowdown after upgrading 2.6.32->3.0
References: <4F75E46E.2000503@msgid.tls.msk.ru> <20120405232913.GA6640@quack.suse.cz>
In-Reply-To: <20120405232913.GA6640@quack.suse.cz>
X-Enigmail-Version: 1.3.4
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.04.2012 03:29, Jan Kara wrote:

> On Fri 30-03-12 20:50:54, Michael Tokarev wrote:
>> I'm observing a dramatic slowdown of several hosts after upgrading
>> from 2.6.32.y to 3.0.x i686 kernels (in both cases from kernel.org,
>> on both cases the last version is relatively latest).
[]
>> What's the way to debug this issue?
>   Identifying a particular kernel where things regresses might help as Jon
> wrote. Just from top of my head, 3.0 had a bug in device plugging so
> readahead was broken. I think it was addressed in -stable series so you

That's definitely not readahead, it since writes are painfully slow
too.  I found one more example -- extlinux --once="test kernel" with
3.0 takes about 20 seconds to complete on an idle system.

> might want to check out latest 3.0-stable.

I did mention this in my initial email (that part quoted above) --
both 2.6.32 and 3.0 are relatively latest from each series,
right now it is 3.0.27.

Yesterday I tried to do some bisection, but ended up in an unbootable
system (it is remote production server), so now I'm waiting for remote
hands to repair it (I don't yet know what went wrong, we'll figure it
out).  I've some time during nights when I can do anything with that
machine, but I have to keep it reachable/working on each reboot.

Apparently I was wrong saying that there's another machine which
suffers from the same issue -- nope, the other machine had an unrelated
issue which I fixed.  So it turns out that from about 200 different
machines, I've just one machine which does not run 3.0 kernel properly.
I especially tried 3.0 on a few more - different - machines last
weekend, in order to see what other machines has this problem, but
found nothing.

So I'll try to continue (or actually _start_) the bisection on this
very server, the way it will be possible having in mind the difficult
conditions.

I just thoght I'd ask first, maybe someone knows offhand what may be
the problem.. ;)

Thank you!

/mjt
