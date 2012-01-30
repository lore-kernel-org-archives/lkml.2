Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab2A3Mm5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 07:42:57 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47106 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835Ab2A3Mmy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 07:42:54 -0500
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Marek Szyprowski" <m.szyprowski@samsung.com>,
        "Mel Gorman" <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
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
Subject: Re: [PATCH 03/15] mm: compaction: introduce
 isolate_migratepages_range().
References: <1327568457-27734-1-git-send-email-m.szyprowski@samsung.com>
 <1327568457-27734-4-git-send-email-m.szyprowski@samsung.com>
 <20120130112428.GF25268@csn.ul.ie>
Date: Mon, 30 Jan 2012 13:42:50 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v8wdlovn3l0zgt@mpn-glaptop>
In-Reply-To: <20120130112428.GF25268@csn.ul.ie>
User-Agent: Opera Mail/11.61 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Jan 26, 2012 at 10:00:45AM +0100, Marek Szyprowski wrote:
>> From: Michal Nazarewicz <mina86@mina86.com>
>> @@ -313,7 +316,7 @@ static isolate_migrate_t isolate_migratepages(struct zone *zone,
>>  		} else if (!locked)
>>  			spin_lock_irq(&zone->lru_lock);
>>
>> -		if (!pfn_valid_within(low_pfn))
>> +		if (!pfn_valid(low_pfn))
>>  			continue;
>>  		nr_scanned++;
>>

On Mon, 30 Jan 2012 12:24:28 +0100, Mel Gorman <mel@csn.ul.ie> wrote:
> This chunk looks unrelated to the rest of the patch.
>
> I think what you are doing is patching around a bug that CMA exposed
> which is very similar to the bug report at
> http://www.spinics.net/lists/linux-mm/msg29260.html . Is this true?
>
> If so, I posted a fix that only calls pfn_valid() when necessary. Can
> you check if that works for you and if so, drop this hunk please? If
> the patch does not work for you, then this hunk still needs to be
> in a separate patch and handled separately as it would also be a fix
> for -stable.

I'll actually never encountered this bug myself and CMA is unlikely to
expose it, since it always operates on continuous memory regions with
no holes.

I've made this change because looking at the code it seemed like this
may cause problems in some cases.  The crash that you linked to looks
like the kind of problem I was thinking about.

I'll drop this hunk and let you resolve this independently of CMA.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
