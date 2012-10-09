Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab2JIAma (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 20:42:30 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61399 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174Ab2JIAmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 20:42:25 -0400
Message-ID: <507372E8.9090207@gmail.com>
Date: Tue, 09 Oct 2012 08:42:16 +0800
From: Ni zhan Chen <nizhan.chen@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Mike Yoknis <mike.yoknis@hp.com>, mingo@redhat.com,
        akpm@linux-foundation.org, linux-arch@vger.kernel.org, mmarek@suse.cz,
        tglx@linutronix.de, hpa@zytor.com, arnd@arndb.de, sam@ravnborg.org,
        minchan@kernel.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: memmap_init_zone() performance improvement
References: <1349276174-8398-1-git-send-email-mike.yoknis@hp.com> <20121008151656.GM29125@suse.de>
In-Reply-To: <20121008151656.GM29125@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2012 11:16 PM, Mel Gorman wrote:
> On Wed, Oct 03, 2012 at 08:56:14AM -0600, Mike Yoknis wrote:
>> memmap_init_zone() loops through every Page Frame Number (pfn),
>> including pfn values that are within the gaps between existing
>> memory sections.  The unneeded looping will become a boot
>> performance issue when machines configure larger memory ranges
>> that will contain larger and more numerous gaps.
>>
>> The code will skip across invalid sections to reduce the
>> number of loops executed.
>>
>> Signed-off-by: Mike Yoknis <mike.yoknis@hp.com>
> This only helps SPARSEMEM and changes more headers than should be
> necessary. It would have been easier to do something simple like
>
> if (!early_pfn_valid(pfn)) {
> 	pfn = ALIGN(pfn + MAX_ORDER_NR_PAGES, MAX_ORDER_NR_PAGES) - 1;
> 	continue;
> }

So if present memoy section in sparsemem can have 
MAX_ORDER_NR_PAGES-aligned range are all invalid?
If the answer is yes, when this will happen?

>
> because that would obey the expectation that pages within a
> MAX_ORDER_NR_PAGES-aligned range are all valid or all invalid (ARM is the
> exception that breaks this rule). It would be less efficient on
> SPARSEMEM than what you're trying to merge but I do not see the need for
> the additional complexity unless you can show it makes a big difference
> to boot times.
>

