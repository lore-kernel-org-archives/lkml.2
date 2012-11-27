Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472Ab2K0XUF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 18:20:05 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:41517 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755663Ab2K0XUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 18:20:01 -0500
MIME-Version: 1.0
In-Reply-To: <20121127222637.GG2301@cmpxchg.org>
References: <1354049315-12874-1-git-send-email-hannes@cmpxchg.org>
 <CA+55aFywygqWUBNWtZYa+vk8G0cpURZbFdC7+tOzyWk6tLi=WA@mail.gmail.com>
 <50B52DC4.5000109@redhat.com> <20121127214928.GA20253@cmpxchg.org>
 <50B5387C.1030005@redhat.com> <20121127222637.GG2301@cmpxchg.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 27 Nov 2012 15:19:38 -0800
X-Google-Sender-Auth: SLGvZnOr9RHSWqBoIp1ONh1QFRE
Message-ID: <CA+55aFyrNRF8nWyozDPi4O1bdjzO189YAgMukyhTOZ9fwKqOpA@mail.gmail.com>
Subject: Re: kswapd craziness in 3.7
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, George Spelvin <linux@horizon.com>,
        Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        Tomas Racek <tracek@redhat.com>, Jan Kara <jack@suse.cz>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Josh Boyer <jwboyer@gmail.com>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Jiri Slaby <jslaby@suse.cz>, Thorsten Leemhuis <fedora@leemhuis.info>,
        Zdenek Kabelac <zkabelac@redhat.com>, Bruno Wolff III <bruno@wolff.to>,
        linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 2:26 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> On Tue, Nov 27, 2012 at 05:02:36PM -0500, Rik van Riel wrote:
>>
>> Kswapd going crazy is certainly a large part of the problem.
>>
>> However, that leaves the issue of page_alloc.c waking up
>> kswapd when the system is not actually low on memory.
>>
>> Instead, kswapd is woken up because memory compaction failed,
>> potentially even due to lock contention during compaction!
>>
>> Ideally the allocation code would only wake up kswapd if
>> memory needs to be freed, or in order for kswapd to do
>> memory compaction (so the allocator does not have to).
>
> Maybe I missed something, but shouldn't this be solved with my patch?

Ok, guys. Cage fight!

The rules are simple: two men enter, one man leaves.

And the one who comes out gets to explain to me which patch(es) I
should apply, and which I should revert, if any.

My current guess is that I should apply the one Johannes just sent
("mm: vmscan: fix kswapd endless loop on higher order allocation")
after having added the cc to stable to it, and then revert the recent
revert (commit 82b212f40059).

But I await the Thunderdome. <Cue Tina Turner "We Don't Need Another Hero">

                      Linus
