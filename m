Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab1JXBAi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 21:00:38 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:48980 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab1JXBAg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 21:00:36 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Mel Gorman" <mel@csn.ul.ie>
Cc: "Marek Szyprowski" <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org,
        "Kyungmin Park" <kyungmin.park@samsung.com>,
        "Russell King" <linux@arm.linux.org.uk>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
        "Ankita Garg" <ankita@in.ibm.com>,
        "Daniel Walker" <dwalker@codeaurora.org>,
        "Arnd Bergmann" <arnd@arndb.de>,
        "Jesse Barker" <jesse.barker@linaro.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        "Shariq Hasnain" <shariq.hasnain@linaro.org>,
        "Chunsang Jeong" <chunsang.jeong@linaro.org>,
        "Dave Hansen" <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/9] mm: alloc_contig_freed_pages() added
References: <1317909290-29832-1-git-send-email-m.szyprowski@samsung.com>
 <1317909290-29832-3-git-send-email-m.szyprowski@samsung.com>
 <20111018122109.GB6660@csn.ul.ie> <op.v3j5ent03l0zgt@mpn-glaptop>
 <20111021100624.GB4029@csn.ul.ie>
Date: Sun, 23 Oct 2011 18:00:30 -0700
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v3tzq4q53l0zgt@mpn-glaptop>
In-Reply-To: <20111021100624.GB4029@csn.ul.ie>
User-Agent: Opera Mail/11.52 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Oct 2011 03:06:24 -0700, Mel Gorman <mel@csn.ul.ie> wrote:

> On Tue, Oct 18, 2011 at 10:26:37AM -0700, Michal Nazarewicz wrote:
>> On Tue, 18 Oct 2011 05:21:09 -0700, Mel Gorman <mel@csn.ul.ie> wrote:
>>
>> >At this point, I'm going to apologise for not reviewing this a long long
>> >time ago.
>> >
>> >On Thu, Oct 06, 2011 at 03:54:42PM +0200, Marek Szyprowski wrote:
>> >>From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> >>
>> >>This commit introduces alloc_contig_freed_pages() function
>> >>which allocates (ie. removes from buddy system) free pages
>> >>in range. Caller has to guarantee that all pages in range
>> >>are in buddy system.
>> >>
>> >
>> >Straight away, I'm wondering why you didn't use
>> >
>> >mm/compaction.c#isolate_freepages()
>> >
>> >It knows how to isolate pages within ranges. All its control information
>> >is passed via struct compact_control() which I recognise may be awkward
>> >for CMA but compaction.c know how to manage all the isolated pages and
>> >pass them to migrate.c appropriately.
>>
>> It is something to consider.  At first glance, I see that isolate_freepages
>> seem to operate on pageblocks which is not desired for CMA.
>>
>
> isolate_freepages_block operates on a range of pages that happens to be
> hard-coded to be a pageblock because that was the requirements. It calculates
> end_pfn and it is possible to make that a function parameter.

Yes, this seems doable.  I'll try and rewrite the patches to use it.

The biggest difference is in how CMA and compaction treat pages which are not
free.  CMA treat it as an error and compaction just skips those.  This is
solvable by an argument though.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
