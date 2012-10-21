Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab2JUCjf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 22:39:35 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:50718 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633Ab2JUCje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 22:39:34 -0400
Message-ID: <50836060.4050408@gmail.com>
Date: Sun, 21 Oct 2012 10:39:28 +0800
From: Ni zhan Chen <nizhan.chen@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Mel Gorman <mel@csn.ul.ie>,
        Linux kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: question on NUMA page migration
References: <5081777A.8050104@redhat.com>
In-Reply-To: <5081777A.8050104@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2012 11:53 PM, Rik van Riel wrote:
> Hi Andrea, Peter,
>
> I have a question on page refcounting in your NUMA
> page migration code.
>
> In Peter's case, I wonder why you introduce a new
> MIGRATE_FAULT migration mode. If the normal page
> migration / compaction logic can do without taking
> an extra reference count, why does your code need it?

Hi Rik van Riel,

This is which part of codes? Why I can't find MIGRATE_FAULT in latest 
v3.7-rc2?

Regards,
Chen

>
> In Andrea's case, we have a comment suggesting an
> extra refcount is needed, immediately followed by
> a put_page:
>
>         /*
>          * Pin the head subpage at least until the first
>          * __isolate_lru_page succeeds (__isolate_lru_page pins it
>          * again when it succeeds). If we unpin before
>          * __isolate_lru_page successd, the page could be freed and
>          * reallocated out from under us. Thus our previous checks on
>          * the page, and the split_huge_page, would be worthless.
>          *
>          * We really only need to do this if "ret > 0" but it doesn't
>          * hurt to do it unconditionally as nobody can reference
>          * "page" anymore after this and so we can avoid an "if (ret >
>          * 0)" branch here.
>          */
>         put_page(page);
>
> This also confuses me.
>
> If we do not need the extra refcount (and I do not
> understand why NUMA migrate-on-fault needs one more
> refcount than normal page migration), we can get
> rid of the MIGRATE_FAULT mode.
>
> If we do need the extra refcount, why is normal
> page migration safe? :)
>

