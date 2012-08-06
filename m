Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130Ab2HFUjG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 16:39:06 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:39913 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755991Ab2HFUjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 16:39:03 -0400
Message-ID: <50202B2F.5000003@linaro.org>
Date: Mon, 06 Aug 2012 13:38:07 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Dave Chinner <david@fromorbit.com>, Neil Brown <neilb@suse.de>,
        Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Mike Hommey <mh@glandium.org>, Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>, dan.magenheimer@oracle.com,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 4/5] [RFC][HACK] Add LRU_VOLATILE support to the VM
References: <1343447832-7182-1-git-send-email-john.stultz@linaro.org> <1343447832-7182-5-git-send-email-john.stultz@linaro.org> <20120806030451.GA11468@bbox>
In-Reply-To: <20120806030451.GA11468@bbox>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12080620-5806-0000-0000-000018164A37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2012 08:04 PM, Minchan Kim wrote:
> Hi John,
>
> On Fri, Jul 27, 2012 at 11:57:11PM -0400, John Stultz wrote:
>> In an attempt to push the volatile range managment even
>> deeper into the VM code, this is my first attempt at
>> implementing Minchan's idea of a LRU_VOLATILE list in
>> the mm core.
>>
>> This list sits along side the LRU_ACTIVE_ANON, _INACTIVE_ANON,
>> _ACTIVE_FILE, _INACTIVE_FILE and _UNEVICTABLE lru lists.
>>
>> When a range is marked volatile, the pages in that range
>> are moved to the LRU_VOLATILE list. Since volatile pages
>> can be quickly purged, this list is the first list we
>> shrink when we need to free memory.
>>
>> When a page is marked non-volatile, it is moved from the
>> LRU_VOLATILE list to the appropriate LRU_ACTIVE_ list.
> I think active list promotion is not good.
> It should go to the inactive list and they get a chance to
> activate from inactive to active sooner or later if it is
> really touched.

Ok. Thanks, I'll change it so we move to the inactive list then.


>> This patch introduces the LRU_VOLATILE list, an isvolatile
>> page flag, functions to mark and unmark a single page
>> as volatile, and shrinker functions to purge volatile
>> pages.
>>
>> This is a very raw first pass, and is neither performant
>> or likely bugfree. It works in my trivial testing, but
>> I've not pushed it very hard yet.
>>
>> I wanted to send it out just to get some inital thoughts
>> on the approach and any suggestions should I be going too
>> far in the wrong direction.
> I look at this series and found several nitpicks about implemenataion
> but I think it's not a good stage about concerning it.

Although while I know the design may still need significant change, I'd 
still appreciate nitpicks, as they might help me better understand the 
mm code and any mistakes I'm making.


> Although naming is rather differet with I suggested, I think it's good idea.
> So let's talk about it firstly.
> I will call VOLATILE list as EReclaimale LRU list.
Yea, I didn't want to call it ERECLAIMABLE since for this iteration I 
was limiting the scope just to volatile pages. I'm totally fine renaming 
it as the scope widens.

thanks
-john

