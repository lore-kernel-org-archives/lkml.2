Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab1JQURE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 16:17:04 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39929 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106Ab1JQURC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 16:17:02 -0400
MIME-Version: 1.0
In-Reply-To: <201110171245.31256.dtor@vmware.com>
References: <1318877852.10091.11.camel@localhost.localdomain>
	<alpine.DEB.2.00.1110171232460.12560@chino.kir.corp.google.com>
	<201110171245.31256.dtor@vmware.com>
Date: Tue, 18 Oct 2011 02:17:02 +0600
Message-ID: <CADZ9YHinpV=7LMRVbwVH4NS_q5b_VhhedbJ5gE7KnKFkg1F1xw@mail.gmail.com>
Subject: Re: [PATCH] drivers, vmw_balloon.c: Increment alloc and sleep_alloc
 only when page allocation succeeds.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Dmitry Torokhov <dtor@vmware.com>
Cc: David Rientjes <rientjes@google.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 1:45 AM, Dmitry Torokhov <dtor@vmware.com> wrote:
> On Monday, October 17, 2011 12:35:34 PM David Rientjes wrote:
>> On Tue, 18 Oct 2011, Rakib Mullick wrote:
>> >  While doing allocation statistics in vmballoon_reserve_page function,
>> >
>> > alloc and sleep_alloc has been incremented even if allocation fails.
>> > But,
>> > b->stats.alloc and b->stats.sleep_alloc supposed to increment only
>> > when they succeed. This patch makes sure that, alloc and sleep_alloc
>> > gets incremented when page allocation succeeds.
>>
>> Dmitry could say for sure, but this seems to actually change the
>> semantics.  If the allocations fail, it increments alloc_fail and
>> sleep_alloc_fail accordingly so you could easily see 10 alloc and 5
>> alloc_fail.  With your patch, it would be 5 alloc and 5 alloc_fail.
>>
>> I don't know which one is best, but I would opt to stay with the
>> semantics that alloc and sleep_alloc have already had rather than
>> changing them.
>
> Right, b->stats.alloc and b->stats.sleep_alloc show number of allocation
> attempts and alloc_fail and sleep_alloc_fail show how many of these
> attempts failed. This behavior matches behavior of the driver we have
> been shipping out of the tree for many years and I would prefer to keep
> it as is.
>
Then why b->stats.alloc and b->stats.sleep_alloc are not renamed as
b->stats.alloc_attempted and b->stats.sleep_alloc_attempted
respectively. Current naming is confusing, anyone looking at the alloc
and sleep_alloc stat would easily think that, if 10 alloc and 5
alloc_fail then 10 has been allocated and 5 times has been allocation
fails. Isn't it?

Thanks,
Rakib
