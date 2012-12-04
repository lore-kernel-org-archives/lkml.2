Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341Ab2LDJPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 04:15:17 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42474 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab2LDJPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 04:15:14 -0500
Message-ID: <50BDBF1D.60105@suse.cz>
Date: Tue, 04 Dec 2012 10:15:09 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Zdenek Kabelac <zkabelac@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, George Spelvin <linux@horizon.com>,
        Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        Thorsten Leemhuis <fedora@leemhuis.info>,
        Tomas Racek <tracek@redhat.com>, Jan Kara <jack@suse.cz>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Josh Boyer <jwboyer@gmail.com>,
        Valdis.Kletnieks@vt.edu, Bruno Wolff III <bruno@wolff.to>,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: kswapd craziness in 3.7
References: <1354049315-12874-1-git-send-email-hannes@cmpxchg.org> <20121128094511.GS8218@suse.de> <50BCC3E3.40804@redhat.com> <20121203191858.GY24381@cmpxchg.org> <50BDBCD9.9060509@redhat.com>
In-Reply-To: <50BDBCD9.9060509@redhat.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2012 10:05 AM, Zdenek Kabelac wrote:
> Dne 3.12.2012 20:18, Johannes Weiner napsal(a):
>> Szia Zdenek,
>>
>> On Mon, Dec 03, 2012 at 04:23:15PM +0100, Zdenek Kabelac wrote:
>>> Ok, bad news - I've been hit by  kswapd0 loop again -
>>> my kernel git commit cc19528bd3084c3c2d870b31a3578da8c69952f3 again
>>> shown kswapd0 for couple minutes on CPU.
>>>
>>> It seemed to go instantly away when I've drop caches
>>> (echo 3 >/proc/sys/vm/drop_cache)
>>> (After that I've had over 1G free memory)
>>
>> Any chance you could retry with this patch on top?

It does not apply to -next :/. Should I try anything else?

>> From: Johannes Weiner <hannes@cmpxchg.org>
>> Subject: [patch] mm: vmscan: do not keep kswapd looping forever due
>>   to individual uncompactable zones
...
> What seems to be triggering condition on my machine - running laptop for
> some days - and having   Thunderbird reaching 0.8G (I guess they must
> keep all my news messages in memory to consume that size) and Firefox
> 1.3GB of consumed
> memory (assuming massive leaking with combination of flash)

Similar here, 5 days of uptime (suspend/resumes in between). FF 900M, TB
250M, java 1.1G, kvm 550M, X 400M, cache 1.5G out of 6G total mem. And boom.

thanks,
-- 
js
suse labs
