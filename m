Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab2LCI0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 03:26:44 -0500
Received: from basicbox7.server-home.net ([195.137.212.29]:49419 "EHLO
	basicbox7.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab2LCI0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 03:26:43 -0500
Message-ID: <50BC6314.7060106@leemhuis.info>
Date: Mon, 03 Dec 2012 09:30:12 +0100
From: Thorsten Leemhuis <fedora@leemhuis.info>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, George Spelvin <linux@horizon.com>,
        Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        Tomas Racek <tracek@redhat.com>, Jan Kara <jack@suse.cz>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Josh Boyer <jwboyer@gmail.com>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Jiri Slaby <jslaby@suse.cz>, Zdenek Kabelac <zkabelac@redhat.com>,
        Bruno Wolff III <bruno@wolff.to>, linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        John Ellson <john.ellson@comcast.net>
Subject: Re: kswapd craziness in 3.7
References: <20121127214928.GA20253@cmpxchg.org> <50B5387C.1030005@redhat.com> <20121127222637.GG2301@cmpxchg.org> <CA+55aFyrNRF8nWyozDPi4O1bdjzO189YAgMukyhTOZ9fwKqOpA@mail.gmail.com> <20121128101359.GT8218@suse.de> <20121128145215.d23aeb1b.akpm@linux-foundation.org> <20121128235412.GW8218@suse.de> <50B77F84.1030907@leemhuis.info> <20121129170512.GI2301@cmpxchg.org> <50B8A8E7.4030108@leemhuis.info> <20121201004520.GK2301@cmpxchg.org>
In-Reply-To: <20121201004520.GK2301@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Johannes Weiner wrote on 01.12.2012 01:45:
> On Fri, Nov 30, 2012 at 01:39:03PM +0100, Thorsten Leemhuis wrote:
>> /me wonders how to elegantly get out of his man-in-the-middle position
> You control the mighty koji :-)

Something even a journalist can ;-)

> But seriously, this is very helpful, thank you!

Np; BTW, in case anybody here on LKML cares: I started maintaining a
side repo (PPA in ubuntu speak) a few weeks ago that offers kernel
vanilla builds (mainline and stable) for the Fedora 17 and 18; see
https://fedoraproject.org/wiki/Kernel_Vanilla_Repositories
for details. It's not as good and up2date yet as I would like it, but
one has to start somewhere.

Back to topic:

> John now also Cc'd directly.
> 
>> John was able to reproduce the problem quickly with a kernel that 
>> contained the patch from your mail. For details see
>
> [stripped: all the glory details of what likely went wrong and lead
> to the problem john sees or saw]
>
> ---
> From: Johannes Weiner <hannes@cmpxchg.org>
> Subject: [patch] mm: vmscan: do not keep kswapd looping forever due
>  to individual uncompactable zones
> 
> When a zone meets its high watermark and is compactable in case of
> higher order allocations, it contributes to the percentage of the
> node's memory that is considered balanced.
> [...]

FYI: I built a kernel with that patch. I've been running on my x86_64
machine at home over the weekend and everything was working fine (just
as without the patch). John gave it a quick try and in
https://bugzilla.redhat.com/show_bug.cgi?id=866988#c57 reported:

"""
I just installed
kernel-3.7.0-0.rc7.git1.2.van.main.knurd.kswap.4.fc18.i686 and ran my
usual load that triggers the problem.  OK so far.  I'll check again in
24hours, but looking good so far.
"""

BTW, I built that kernel without the patch you mentioned in
http://thread.gmane.org/gmane.linux.kernel.mm/90911/focus=91153
("buffer_heads_over_limit can put kswapd into reclaim, but it's ignored
[...]) It looked to me like that patch was only meant for debugging. Let
me know if that was wrong. Ohh, and I didn't update to a fresher
mainline checkout yet to make sure the base for John's testing didn't
change.

CU
 Thorsten
