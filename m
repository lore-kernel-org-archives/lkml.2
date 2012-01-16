Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab2APMsQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 07:48:16 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:57891 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab2APMsP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 07:48:15 -0500
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
        "Daniel Walker" <dwalker@codeaurora.org>,
        "Arnd Bergmann" <arnd@arndb.de>,
        "Jesse Barker" <jesse.barker@linaro.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        "Shariq Hasnain" <shariq.hasnain@linaro.org>,
        "Chunsang Jeong" <chunsang.jeong@linaro.org>,
        "Dave Hansen" <dave@linux.vnet.ibm.com>,
        "Benjamin Gaignard" <benjamin.gaignard@linaro.org>
Subject: Re: [PATCH 04/11] mm: page_alloc: introduce alloc_contig_range()
References: <1325162352-24709-1-git-send-email-m.szyprowski@samsung.com>
 <1325162352-24709-5-git-send-email-m.szyprowski@samsung.com>
 <20120110141613.GB3910@csn.ul.ie> <op.v71gpt1b3l0zgt@mpn-glaptop>
 <20120116090110.GA2929@csn.ul.ie>
Date: Mon, 16 Jan 2012 13:48:11 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v76giluf3l0zgt@mpn-glaptop>
In-Reply-To: <20120116090110.GA2929@csn.ul.ie>
User-Agent: Opera Mail/11.60 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jan 2012 10:01:10 +0100, Mel Gorman <mel@csn.ul.ie> wrote:

> On Fri, Jan 13, 2012 at 09:04:31PM +0100, Michal Nazarewicz wrote:
>> >On Thu, Dec 29, 2011 at 01:39:05PM +0100, Marek Szyprowski wrote:
>> >>From: Michal Nazarewicz <mina86@mina86.com>
>> >>+	/* Make sure all pages are isolated. */
>> >>+	if (!ret) {
>> >>+		lru_add_drain_all();
>> >>+		drain_all_pages();
>> >>+		if (WARN_ON(test_pages_isolated(start, end)))
>> >>+			ret = -EBUSY;
>> >>+	}
>>
>> On Tue, 10 Jan 2012 15:16:13 +0100, Mel Gorman <mel@csn.ul.ie> wrote:
>> >Another global IPI seems overkill. Drain pages only from the local CPU
>> >(drain_pages(get_cpu()); put_cpu()) and test if the pages are isolated.
>>
>> Is get_cpu() + put_cpu() required? Won't drain_local_pages() work?
>>
>
> drain_local_pages() calls smp_processor_id() without preemption
> disabled.

Thanks, I wasn't sure if preemption is an issue.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
