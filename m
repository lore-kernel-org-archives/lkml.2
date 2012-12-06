Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab2LFUeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 15:34:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361Ab2LFUeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 15:34:06 -0500
Message-ID: <50C100D2.4010103@redhat.com>
Date: Thu, 06 Dec 2012 15:32:18 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Bruno Wolff III <bruno@wolff.to>,
        Thorsten Leemhuis <fedora@leemhuis.info>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        George Spelvin <linux@horizon.com>,
        Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        Tomas Racek <tracek@redhat.com>, Jan Kara <jack@suse.cz>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Josh Boyer <jwboyer@gmail.com>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Jiri Slaby <jslaby@suse.cz>, Zdenek Kabelac <zkabelac@redhat.com>,
        linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        John Ellson <john.ellson@comcast.net>
Subject: Re: kswapd craziness in 3.7
References: <50B77F84.1030907@leemhuis.info> <20121129170512.GI2301@cmpxchg.org> <50B8A8E7.4030108@leemhuis.info> <20121201004520.GK2301@cmpxchg.org> <50BC6314.7060106@leemhuis.info> <20121203194208.GZ24381@cmpxchg.org> <20121204214210.GB20253@cmpxchg.org> <20121205030133.GA17438@wolff.to> <20121206173742.GA27297@wolff.to> <CA+55aFzZsCUk6snrsopWQJQTXLO__G7=SjrGNyK3ePCEtZo7Sw@mail.gmail.com> <20121206202325.GA1498@cmpxchg.org>
In-Reply-To: <20121206202325.GA1498@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2012 03:23 PM, Johannes Weiner wrote:

> From: Johannes Weiner <hannes@cmpxchg.org>
> Subject: [patch] mm: vmscan: fix inappropriate zone congestion clearing
>
> c702418 ("mm: vmscan: do not keep kswapd looping forever due to
> individual uncompactable zones") removed zone watermark checks from
> the compaction code in kswapd but left in the zone congestion
> clearing, which now happens unconditionally on higher order reclaim.
>
> This messes up the reclaim throttling logic for zones with
> dirty/writeback pages, where zones should only lose their congestion
> status when their watermarks have been restored.
>
> Remove the clearing from the zone compaction section entirely.  The
> preliminary zone check and the reclaim loop in kswapd will clear it if
> the zone is considered balanced.
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
