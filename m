Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855Ab2LTJ3t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 04:29:49 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:62585 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab2LTJ3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 04:29:42 -0500
Message-ID: <50D2DA7F.3030902@openvz.org>
Date: Thu, 20 Dec 2012 13:29:35 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121123 Firefox/10.0.11 Iceape/2.7.11
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] mm/swap: add independed bio pool for swap
References: <20121214110118.8387.66431.stgit@zurg> <alpine.LNX.2.00.1212172024500.5927@eggly.anvils> <20121219165343.ccb3a956.akpm@linux-foundation.org>
In-Reply-To: <20121219165343.ccb3a956.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 17 Dec 2012 20:45:13 -0800 (PST)
> Hugh Dickins<hughd@google.com>  wrote:
>
>> On Fri, 14 Dec 2012, Konstantin Khlebnikov wrote:
>>
>>> This bio pool guarantees reclaiming progress for anonymous pages.
>>> All avaliable bio in fs_bio_set may be borrowed by writeback which may
>>> never ends, because disk too slow or broken. I have seen this situation in
>>> real life in system where was a lot of bio requests to a loop device which
>>> laying on top of special fuse-based filesystem.
>>
>> Hmm, perhaps, I'm not at all sure.
>
> It probably maybe perhaps makes sense.  Of course, you're screwed if
> one of your swap devices is "disk too slow or broken".
>
> My crystal ball tells me that the 2015 kernel will have a bioset per
> physical device...
>

I predict that they also will be per-cpu. Well... probably maybe we should
just wait for this shining future. I leave this to your discretion...
