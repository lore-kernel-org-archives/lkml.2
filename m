Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933064Ab0GTXDN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 19:03:13 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56462 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932927Ab0GTXDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 19:03:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=PYh0TB7ZIvOGsFJ3qzQwz0+4FqKKmYR9Ebk4KD3rHjZ29ngawmaeYUTNyVE+wrMzE2
         dxiCdYBY2uKcSRRUfM9vHtq3zrJ8WsKuO537oBPC4kzmzW9lp7fqTW2loGh6Bo3eYruy
         FARJNR1zTKftXPvt2ewUlpYhbY5dplR6n80uc=
MIME-Version: 1.0
In-Reply-To: <1279283870-18549-5-git-send-email-ngupta@vflare.org>
References: <1279283870-18549-1-git-send-email-ngupta@vflare.org>
	<1279283870-18549-5-git-send-email-ngupta@vflare.org>
Date: Wed, 21 Jul 2010 08:03:09 +0900
Message-ID: <AANLkTinaX-huEMGP-k4mCSr0USQhJp68AUgOf4FHqr5Q@mail.gmail.com>
Subject: Re: [PATCH 4/8] Shrink zcache based on memlimit
From: Minchan Kim <minchan.kim@gmail.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Rik van Riel <riel@redhat.com>, Avi Kivity <avi@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jul 16, 2010 at 9:37 PM, Nitin Gupta <ngupta@vflare.org> wrote:
> User can change (per-pool) memlimit using sysfs node:
> /sys/kernel/mm/zcache/pool<id>/memlimit
>
> When memlimit is set to a value smaller than current
> number of pages allocated for that pool, excess pages
> are now freed immediately instead of waiting for get/
> flush for these pages.
>
> Currently, victim page selection is essentially random.
> Automatic cache resizing and better page replacement
> policies will be implemented later.

Okay. I know this isn't end. I just want to give a concern before you end up.
I don't know how you implement reclaim policy.
In current implementation, you use memlimit for determining when reclaim happen.
But i think we also should follow global reclaim policy of VM.
I means although memlimit doen't meet, we should reclaim zcache if
system has a trouble to reclaim memory.
AFAIK, cleancache doesn't give any hint for that. so we should
implement it in zcache itself.
At first glance, we can use shrink_slab or oom_notifier. But both
doesn't give any information of zone although global reclaim do it by
per-zone.
AFAIK, Nick try to implement zone-aware shrink slab. Also if we need
it, we can change oom_notifier with zone-aware oom_notifier. Now it
seems anyone doesn't use oom_notifier so I am not sure it's useful.

It's just my opinion.
Thanks for effort for good feature. Nitin.
-- 
Kind regards,
Minchan Kim
