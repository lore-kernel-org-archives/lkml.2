Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762613Ab0GUFV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:21:57 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34028 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277Ab0GUEwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:52:17 -0400
Message-ID: <4C467D18.4050901@vflare.org>
Date: Wed, 21 Jul 2010 10:22:40 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.4) Gecko/20100624 Fedora/3.1-1.fc13 Thunderbird/3.1
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Rik van Riel <riel@redhat.com>, Avi Kivity <avi@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/8] Shrink zcache based on memlimit
References: <1279283870-18549-1-git-send-email-ngupta@vflare.org>	<1279283870-18549-5-git-send-email-ngupta@vflare.org> <AANLkTinaX-huEMGP-k4mCSr0USQhJp68AUgOf4FHqr5Q@mail.gmail.com>
In-Reply-To: <AANLkTinaX-huEMGP-k4mCSr0USQhJp68AUgOf4FHqr5Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2010 04:33 AM, Minchan Kim wrote:
> On Fri, Jul 16, 2010 at 9:37 PM, Nitin Gupta <ngupta@vflare.org> wrote:
>> User can change (per-pool) memlimit using sysfs node:
>> /sys/kernel/mm/zcache/pool<id>/memlimit
>>
>> When memlimit is set to a value smaller than current
>> number of pages allocated for that pool, excess pages
>> are now freed immediately instead of waiting for get/
>> flush for these pages.
>>
>> Currently, victim page selection is essentially random.
>> Automatic cache resizing and better page replacement
>> policies will be implemented later.
> 
> Okay. I know this isn't end. I just want to give a concern before you end up.
> I don't know how you implement reclaim policy.
> In current implementation, you use memlimit for determining when reclaim happen.
> But i think we also should follow global reclaim policy of VM.
> I means although memlimit doen't meet, we should reclaim zcache if
> system has a trouble to reclaim memory.

Yes, we should have a way to do reclaim depending on system memory pressure
and also when user explicitly wants so i.e. when memlimit is lowered manually.

> AFAIK, cleancache doesn't give any hint for that. so we should
> implement it in zcache itself.

I think cleancache should be kept minimal so yes, all reclaim policies should
go in zcache layer only.

> At first glance, we can use shrink_slab or oom_notifier. But both
> doesn't give any information of zone although global reclaim do it by
> per-zone.
> AFAIK, Nick try to implement zone-aware shrink slab. Also if we need
> it, we can change oom_notifier with zone-aware oom_notifier. Now it
> seems anyone doesn't use oom_notifier so I am not sure it's useful.
> 

I don't think we need these notifiers as we can simply create a thread
to monitor cache hit rate, system memory pressure etc. and shrink/expand
the cache accordingly.


Thanks for your comments.
Nitin
