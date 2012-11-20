Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab2KTDUd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 22:20:33 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50383 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab2KTDUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 22:20:32 -0500
Message-ID: <50AAF6F3.8010203@gmail.com>
Date: Tue, 20 Nov 2012 11:20:19 +0800
From: Jaegeuk Hanse <jaegeuk.hanse@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@huawei.com>
CC: Jiang Liu <liuj97@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
        Wen Congyang <wency@cn.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Chris Clayton <chris2553@googlemail.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFT PATCH v1 0/5] fix up inaccurate zone->present_pages
References: <20121115112454.e582a033.akpm@linux-foundation.org> <1353254850-27336-1-git-send-email-jiang.liu@huawei.com> <50AAE72E.3090101@gmail.com> <50AAEE61.2090504@huawei.com>
In-Reply-To: <50AAEE61.2090504@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2012 10:43 AM, Jiang Liu wrote:
> On 2012-11-20 10:13, Jaegeuk Hanse wrote:
>> On 11/19/2012 12:07 AM, Jiang Liu wrote:
>>> The commit 7f1290f2f2a4 ("mm: fix-up zone present pages") tries to
>>> resolve an issue caused by inaccurate zone->present_pages, but that
>>> fix is incomplete and causes regresions with HIGHMEM. And it has been
>>> reverted by commit
>>> 5576646 revert "mm: fix-up zone present pages"
>>>
>>> This is a following-up patchset for the issue above. It introduces a
>>> new field named "managed_pages" to struct zone, which counts pages
>>> managed by the buddy system from the zone. And zone->present_pages
>>> is used to count pages existing in the zone, which is
>>>      spanned_pages - absent_pages.
>>>
>>> But that way, zone->present_pages will be kept in consistence with
>>> pgdat->node_present_pages, which is sum of zone->present_pages.
>>>
>>> This patchset has only been tested on x86_64 with nobootmem.c. So need
>>> help to test this patchset on machines:
>>> 1) use bootmem.c
>> If only x86_32 use bootmem.c instead of nobootmem.c? How could I confirm it?
> Hi Jaegeuk,
> 	Thanks for review this patch set.
> 	Currently x86/x86_64/Sparc have been converted to use nobootmem.c,
> and other Arches still use bootmem.c. So need to test it on other Arches,
> such as ARM etc. Yesterday we have tested it patchset on an Itanium platform,
> so bootmem.c should work as expected too.

Hi Jiang,

If there are any codes changed in x86/x86_64  to meet nobootmem.c logic? 
I mean if remove
config NO_BOOTMEM
        def_bool y
in arch/x86/Kconfig, whether x86/x86_64 can take advantage of bootmem.c 
or not.

Regards,
Jaegeuk

> 	Thanks!
> 	Gerry
>
>

