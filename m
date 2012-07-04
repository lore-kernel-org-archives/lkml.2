Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933882Ab2GDKt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 06:49:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:27942 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756961Ab2GDKt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 06:49:56 -0400
X-IronPort-AV: E=Sophos;i="4.77,522,1336320000"; 
   d="scan'208";a="5328418"
Message-ID: <4FF41FF2.1010600@cn.fujitsu.com>
Date: Wed, 04 Jul 2012 18:50:26 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Chris Metcalf <cmetcalf@tilera.com>, Len Brown <lenb@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andi Kleen <andi@firstfloor.org>, Julia Lawall <julia@diku.dk>,
        David Howells <dhowells@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kay Sievers <kay.sievers@vrfy.org>, Ingo Molnar <mingo@elte.hu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Daniel Kiper <dkiper@net-space.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan@kernel.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Rik van Riel <riel@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC PATCH 2/3 V1] mm, page migrate: add MIGRATE_HOTREMOVE type
References: <1341386778-8002-1-git-send-email-laijs@cn.fujitsu.com> <1341386778-8002-3-git-send-email-laijs@cn.fujitsu.com> <20120704101942.GM13141@csn.ul.ie>
In-Reply-To: <20120704101942.GM13141@csn.ul.ie>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/04 18:49:53,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/04 18:49:57,
	Serialize complete at 2012/07/04 18:49:57
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2012 06:19 PM, Mel Gorman wrote:
> On Wed, Jul 04, 2012 at 03:26:17PM +0800, Lai Jiangshan wrote:
>> MIGRATE_HOTREMOVE is a special kind of MIGRATE_MOVABLE, but it is stable:
>> any page of the type can NOT be changed to the other type nor be moved to
>> the other free list.
>>
>> So the pages of MIGRATE_HOTREMOVE are always movable, this ability is
>> useful for hugepages and hotremove ...etc.
>>
>> MIGRATE_HOTREMOVE pages is the used as the first candidate when
>> we allocate movable pages.
>>
>> 1) add small routine is_migrate_movable() for movable-like types
>> 2) add small routine is_migrate_stable() for stable types
>> 3) fix some comments
>> 4) fix get_any_page(). The get_any_page() may change
>>    MIGRATE_CMA/HOTREMOVE types page to MOVABLE which may cause this page
>>    to be changed to UNMOVABLE.
>>
> 
> Reuse MIGRATE_CMA. 

Will do it.

> Even if the pages are on the movable lists it should
> not be a problem for memory hot-remove.

It does have problem, unmovable pages may be allocated on it.

The movable lists can be used for other type when ohter type is empty.
Or we can rename current movable-lists to movable-preference-lists.

Thanks,
Lai

