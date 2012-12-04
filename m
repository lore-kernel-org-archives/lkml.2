Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353Ab2LDJIK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 04:08:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659Ab2LDJIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 04:08:07 -0500
Message-ID: <50BDBCD9.9060509@redhat.com>
Date: Tue, 04 Dec 2012 10:05:29 +0100
From: Zdenek Kabelac <zkabelac@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, George Spelvin <linux@horizon.com>,
        Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        Thorsten Leemhuis <fedora@leemhuis.info>,
        Tomas Racek <tracek@redhat.com>, Jan Kara <jack@suse.cz>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Josh Boyer <jwboyer@gmail.com>,
        Valdis.Kletnieks@vt.edu, Jiri Slaby <jslaby@suse.cz>,
        Bruno Wolff III <bruno@wolff.to>,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: kswapd craziness in 3.7
References: <1354049315-12874-1-git-send-email-hannes@cmpxchg.org> <20121128094511.GS8218@suse.de> <50BCC3E3.40804@redhat.com> <20121203191858.GY24381@cmpxchg.org>
In-Reply-To: <20121203191858.GY24381@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 3.12.2012 20:18, Johannes Weiner napsal(a):
> Szia Zdenek,
>
> On Mon, Dec 03, 2012 at 04:23:15PM +0100, Zdenek Kabelac wrote:
>> Ok, bad news - I've been hit by  kswapd0 loop again -
>> my kernel git commit cc19528bd3084c3c2d870b31a3578da8c69952f3 again
>> shown kswapd0 for couple minutes on CPU.
>>
>> It seemed to go instantly away when I've drop caches
>> (echo 3 >/proc/sys/vm/drop_cache)
>> (After that I've had over 1G free memory)
>
> Any chance you could retry with this patch on top?
>
> ---
> From: Johannes Weiner <hannes@cmpxchg.org>
> Subject: [patch] mm: vmscan: do not keep kswapd looping forever due
>   to individual uncompactable zones
>
> ---
>   mm/vmscan.c | 16 ----------------
>   1 file changed, 16 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c


Ok, I'm running now b69f0859dc8e633c5d8c06845811588fe17e68b3 (-rc8)
with your patch.  I'll be able to give some feedback after couple
days (if I keep my machine running without reboot - since before
I had occasional problems with ACPI now resolved.
(https://bugzilla.kernel.org/show_bug.cgi?id=51071)
(patch not yet in -rc8)
I'm also using this extra patch: https://patchwork.kernel.org/patch/1792531/

What seems to be triggering condition on my machine - running laptop for some 
days - and having   Thunderbird reaching 0.8G (I guess they must keep all my 
news messages in memory to consume that size) and Firefox 1.3GB of consumed
memory (assuming massive leaking with combination of flash)

Zdenek

