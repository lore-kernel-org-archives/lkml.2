Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091Ab0GAKTI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 06:19:08 -0400
Received: from smtp.nokia.com ([192.100.122.230]:42585 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314Ab0GAKTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 06:19:06 -0400
Message-ID: <4C2C6B7D.60905@nokia.com>
Date: Thu, 01 Jul 2010 13:18:37 +0300
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jens Axboe <axboe@kernel.dk>, Kyungmin Park <kmpark@infradead.org>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       linux-mmc Mailing List <linux-mmc@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 4/5] block: Add secure discard
References: <20100624084351.25444.30143.sendpatchset@ahunter-work.research.nokia.com>	<20100624084423.25444.1011.sendpatchset@ahunter-work.research.nokia.com> <20100630150947.d53200ac.akpm@linux-foundation.org>
In-Reply-To: <20100630150947.d53200ac.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Jul 2010 10:18:38.0704 (UTC) FILETIME=[C5AB7F00:01CB1906]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 24 Jun 2010 11:44:23 +0300
> Adrian Hunter <adrian.hunter@nokia.com> wrote:
> 
>> >From b25b9a499f255ee5999c219525d82ef40382318c Mon Sep 17 00:00:00 2001
>> From: Adrian Hunter <adrian.hunter@nokia.com>
>> Date: Wed, 23 Jun 2010 15:41:38 +0300
>> Subject: [PATCH 4/5] block: Add secure discard
>>
>> Secure discard is the same as discard except that all copies
>> of the discarded sectors (perhaps created by garbage collection)
>> must also be erased.
> 
> That's not an awfully informative changelog.
> 
>>From a quick peek at the code it seems that you took your earlier
> design sketch:
> 
> On Mon, Jun 14, 2010 at 02:10:06PM +0300, Adrian Hunter wrote:
>> Needs a bio flag, a request flag, setup the request flag based on the
>> bio flag, prevent merging secure and non-secure discards, prevent drivers
>> doing non-secure discards for secure discards.
>>
>> Seems like a lot of little changes for something that no one wants.
>> Shouldn't it wait for someone to need it first?
> 
> and changed your mind and implemented it.
> 
> Is that a correct interpretation?
> 

Yes.  It does allude to that in "[PATCH V3 0/5] Add MMC erase and secure erase V3"
i.e.

Changes from V2

- move the addition of BLKSECDISCARD to a separate patch and implement it
using I/O requests
- move the MMC support of secure discard to a separate patch and support
the secure discard I/O request
