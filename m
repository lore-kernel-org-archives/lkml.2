Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab2AEPF6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 10:05:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754361Ab2AEPF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 10:05:57 -0500
Message-ID: <4F05BC1F.7070009@redhat.com>
Date: Thu, 05 Jan 2012 10:05:03 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: leonid.moiseichuk@nokia.com, kamezawa.hiroyu@jp.fujitsu.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, cesarb@cesarb.net,
        emunson@mgebm.net, aarcange@redhat.com, mel@csn.ul.ie,
        rientjes@google.com, dima@android.com, gregkh@suse.de,
        rebecca@android.com, san@google.com, akpm@linux-foundation.org,
        vesa.jaaskelainen@nokia.com
Subject: Re: [PATCH 3.2.0-rc1 2/3] MM hook for page allocation and release
References: <cover.1325696593.git.leonid.moiseichuk@nokia.com> <e78b4ac9d3d51ac16180114c08733e4bf62ec65e.1325696593.git.leonid.moiseichuk@nokia.com> <20120105155950.9e49651b.kamezawa.hiroyu@jp.fujitsu.com> <84FF21A720B0874AA94B46D76DB9826904554270@008-AM1MPN1-003.mgdnok.nokia.com> <CAOJsxLF706VeThxqWostJr84N_8q8UXoQzxGmMXj8mpgTLCagg@mail.gmail.com>
In-Reply-To: <CAOJsxLF706VeThxqWostJr84N_8q8UXoQzxGmMXj8mpgTLCagg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2012 07:49 AM, Pekka Enberg wrote:
> On Thu, Jan 5, 2012 at 1:26 PM,<leonid.moiseichuk@nokia.com>  wrote:
>> I agree that hooking alloc_pages is ugly way. So alternatives I see:
>>
>> - shrinkers (as e.g. Android OOM used) but shrink_slab called only from
>> try_to_free_pages only if we are on slow reclaim path on memory allocation,
>> so it cannot be used for e.g. 75% memory tracking or when pages released to
>> notify user space that we are OK. But according to easy to use it will be the
>> best approach.

Well, there is always the page cache.

If, at reclaim time, the amount of page cache + free memory
is below the free threshold, we should still have space left
to handle userspace things.

It may be possible to hijack memcg accounting to get lower
usage thresholds for earlier notification.  That way the code
can stay out of the true fast paths like alloc_pages.

-- 
All rights reversed
