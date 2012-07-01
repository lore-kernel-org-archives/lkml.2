Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123Ab2GAXfc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 19:35:32 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:44674 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755681Ab2GAXfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 19:35:30 -0400
X-AuditID: 9c930197-b7b49ae0000027b8-4c-4ff0dec035f5
Message-ID: <4FF0DEE2.5080200@kernel.org>
Date: Mon, 02 Jul 2012 08:36:02 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Rafael Aquini <aquini@redhat.com>
CC: linux-mm@kvack.org, Rik van Riel <riel@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 1/4] mm: introduce compaction and migration for virtio
 ballooned pages
References: <cover.1340916058.git.aquini@redhat.com> <d0f33a6492501a0d420abbf184f9b956cff3e3fc.1340916058.git.aquini@redhat.com> <4FED3DDB.1000903@kernel.org> <20120629173653.GA1774@t510.redhat.com> <20120629220333.GA2079@barrios> <20120630013447.GA1545@x61.redhat.com>
In-Reply-To: <20120630013447.GA1545@x61.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2012 10:34 AM, Rafael Aquini wrote:

>> void isolate_page_from_balloonlist(struct page* page)
>> > {
>> > 	page->mapping->a_ops->invalidatepage(page, 0);
>> > }
>> > 
>> > 	if (is_balloon_page(page) && (page_count(page) == 2)) {
>> > 		isolate_page_from_balloonlist(page);
>> > 	}
>> > 
> Humm, my feelings on your approach here: just an unecessary indirection that
> doesn't bring the desired code readability improvement.
> If the header comment statement on balloon_mapping->a_ops is not clear enough 
> on those methods usage for ballooned pages:
> 
> ..... 
> /*
>  * Balloon pages special page->mapping.
>  * users must properly allocate and initialize an instance of balloon_mapping,
>  * and set it as the page->mapping for balloon enlisted page instances.
>  *
>  * address_space_operations necessary methods for ballooned pages:
>  *   .migratepage    - used to perform balloon's page migration (as is)
>  *   .invalidatepage - used to isolate a page from balloon's page list
>  *   .freepage       - used to reinsert an isolated page to balloon's page list
>  */
> struct address_space *balloon_mapping;
> EXPORT_SYMBOL_GPL(balloon_mapping);
> .....
> 
> I can add an extra commentary, to recollect folks about that usage, next to the
> points where those callbacks are used at isolate_balloon_page() &
> putback_balloon_page(). What do you think?
> 
> 


I am not strongly against you.
It trivial nitpick must not prevent your great work. :)

Thanks!


-- 
Kind regards,
Minchan Kim
