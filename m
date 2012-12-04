Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab2LDIzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 03:55:09 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47477 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab2LDIzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 03:55:07 -0500
Message-ID: <50BDBA64.8080404@suse.cz>
Date: Tue, 04 Dec 2012 09:55:00 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, George Spelvin <linux@horizon.com>,
        Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        Tomas Racek <tracek@redhat.com>, Jan Kara <jack@suse.cz>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Josh Boyer <jwboyer@gmail.com>,
        Valdis.Kletnieks@vt.edu, Thorsten Leemhuis <fedora@leemhuis.info>,
        Zdenek Kabelac <zkabelac@redhat.com>, Bruno Wolff III <bruno@wolff.to>,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: kswapd craziness in 3.7
References: <1354049315-12874-1-git-send-email-hannes@cmpxchg.org> <50BCA59D.6040704@suse.cz>
In-Reply-To: <50BCA59D.6040704@suse.cz>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2012 02:14 PM, Jiri Slaby wrote:
> On 11/27/2012 09:48 PM, Johannes Weiner wrote:
>> I hope I included everybody that participated in the various threads
>> on kswapd getting stuck / exhibiting high CPU usage.  We were looking
>> at at least three root causes as far as I can see, so it's not really
>> clear who observed which problem.  Please correct me if the
>> reported-by, tested-by, bisected-by tags are incomplete.
> 
> Hi, I reported the problem for the first time but I got lost in the
> patches flying around very early.
> 
> Whatever is in the current -next, works for me since -next was
> resurrected after the 2 weeks gap last week...

Bah, I always need to write an email to reproduce that. It's back:
3.7.0-rc7-next-20121130

[<ffffffff810b132a>] __cond_resched+0x2a/0x40
[<ffffffff81133770>] shrink_slab+0x1c0/0x2d0
[<ffffffff8113668d>] kswapd+0x65d/0xb50
[<ffffffff810a37b0>] kthread+0xc0/0xd0
[<ffffffff816ba4dc>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff

Going to apply this:
https://lkml.org/lkml/2012/12/3/407
and wait another 5 days to see the results...

thanks,
-- 
js
suse labs
