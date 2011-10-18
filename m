Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab1JRS7R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 14:59:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40657 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649Ab1JRS7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 14:59:17 -0400
Date: Tue, 18 Oct 2011 20:59:13 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Dave Jones <davej@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        p.herz@profihost.ag, linux-kernel@vger.kernel.org
Subject: Re: Vanilla-Kernel 3 - page allocation failure
Message-ID: <20111018185913.GE15908@one.firstfloor.org>
References: <4E9D53FF.7090609@profihost.ag> <m2ipnmz49x.fsf@firstfloor.org> <20111018170204.GA10551@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111018170204.GA10551@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We get reports like this fairly regularly, usually accompanied by
> "But I had lots of free memory and/or swap!"

I think the backtrace is also really bad. It just makes it look like a crash.
It just cries "please report me", even though there's usually no good
reason for it.

I understand it can be useful sometimes for debugging, but most of the
time it is unnecessary and just confusing. One good thing probably
would be some heuristic to see when to print the backtrace, and don't
print it in common situations.

> 
> The order/mode stuff is completely opaque to end-users, who have no
> clue that there are different types of memory, and exhausting one type
> can happen even when plenty of other memory is free.

order should be probably replaced with a user readable size, agreed.

order:2 = "16 KB"

[note if anybody wants to reply now it should be "16 KiB", don't bother;
i'll ignore you]
> 
> I've been toying with the idea of hacking up a patch to turn those mode
> flags into printing things like "mode:GFP_ATOMIC|GFP_NOIO" instead though, as I can
> never remember those flags off the top of my head.
> Still won't help end-users, but it would at least speed up diagnosing reports.

Better decode it: "from interrupt handler", "inside a file system"

Unfortunately there's no flag for GFP_ATOMIC but not in a interrupt handler,
but some code with broken locking abusing it. Perhaps there should be.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
