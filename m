Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932602Ab2AEPSY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 10:18:24 -0500
Received: from smtp.nokia.com ([147.243.128.24]:32360 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755450Ab2AEPSX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 10:18:23 -0500
From: <leonid.moiseichuk@nokia.com>
To: <riel@redhat.com>, <penberg@kernel.org>
CC: <kamezawa.hiroyu@jp.fujitsu.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <cesarb@cesarb.net>,
        <emunson@mgebm.net>, <aarcange@redhat.com>, <mel@csn.ul.ie>,
        <rientjes@google.com>, <dima@android.com>, <gregkh@suse.de>,
        <rebecca@android.com>, <san@google.com>, <akpm@linux-foundation.org>,
        <vesa.jaaskelainen@nokia.com>
Subject: RE: [PATCH 3.2.0-rc1 2/3] MM hook for page allocation and release
Thread-Topic: [PATCH 3.2.0-rc1 2/3] MM hook for page allocation and release
Thread-Index: AQHMy3eesLomgDcz/UG8qdbzjsIuzJX9l2wggAAR3QCAACXRgIAAEWHw
Date: Thu, 5 Jan 2012 15:17:26 +0000
Message-ID: <84FF21A720B0874AA94B46D76DB9826904554575@008-AM1MPN1-003.mgdnok.nokia.com>
References: <cover.1325696593.git.leonid.moiseichuk@nokia.com>
 <e78b4ac9d3d51ac16180114c08733e4bf62ec65e.1325696593.git.leonid.moiseichuk@nokia.com>
 <20120105155950.9e49651b.kamezawa.hiroyu@jp.fujitsu.com>
 <84FF21A720B0874AA94B46D76DB9826904554270@008-AM1MPN1-003.mgdnok.nokia.com>
 <CAOJsxLF706VeThxqWostJr84N_8q8UXoQzxGmMXj8mpgTLCagg@mail.gmail.com>
 <4F05BC1F.7070009@redhat.com>
In-Reply-To: <4F05BC1F.7070009@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.23.171]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginalArrivalTime: 05 Jan 2012 15:17:27.0553 (UTC) FILETIME=[22887F10:01CCCBBD]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q05FIW0B020529

Huh,
Early notification not much better then late. Cache size impacts mostly user-space responsiveness, so cache is accounted as free memory but device need be tuned development time according how fast it should be in different device-specific use-cases (it depends from zillions technical and non-technical factors e.g.  producer needs).
I fixed all known findings and trying to find places to integrate into vmscan/page-writeback as Pekka has advised. 

With Best Wishes,
Leonid


-----Original Message-----
From: ext Rik van Riel [mailto:riel@redhat.com] 
Sent: 05 January, 2012 17:05
To: Pekka Enberg
Cc: Moiseichuk Leonid (Nokia-MP/Helsinki); kamezawa.hiroyu@jp.fujitsu.com; linux-mm@kvack.org; linux-kernel@vger.kernel.org; cesarb@cesarb.net; emunson@mgebm.net; aarcange@redhat.com; mel@csn.ul.ie; rientjes@google.com; dima@android.com; gregkh@suse.de; rebecca@android.com; san@google.com; akpm@linux-foundation.org; Jaaskelainen Vesa (Nokia-MP/Helsinki)
Subject: Re: [PATCH 3.2.0-rc1 2/3] MM hook for page allocation and release

On 01/05/2012 07:49 AM, Pekka Enberg wrote:
> On Thu, Jan 5, 2012 at 1:26 PM,<leonid.moiseichuk@nokia.com>  wrote:
>> I agree that hooking alloc_pages is ugly way. So alternatives I see:
>>
>> - shrinkers (as e.g. Android OOM used) but shrink_slab called only 
>> from try_to_free_pages only if we are on slow reclaim path on memory 
>> allocation, so it cannot be used for e.g. 75% memory tracking or when 
>> pages released to notify user space that we are OK. But according to 
>> easy to use it will be the best approach.

Well, there is always the page cache.

If, at reclaim time, the amount of page cache + free memory is below the free threshold, we should still have space left to handle userspace things.

It may be possible to hijack memcg accounting to get lower usage thresholds for earlier notification.  That way the code can stay out of the true fast paths like alloc_pages.

--
All rights reversed
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
