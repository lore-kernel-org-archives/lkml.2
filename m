Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062Ab2DXXvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 19:51:15 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54419 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907Ab2DXXvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 19:51:14 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F973BF2.4080406@jp.fujitsu.com>
Date: Wed, 25 Apr 2012 08:49:06 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Nick Piggin <npiggin@gmail.com>, Minchan Kim <minchan@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC] propagate gfp_t to page table alloc functions
References: <1335171318-4838-1-git-send-email-minchan@kernel.org> <4F963742.2030607@jp.fujitsu.com> <4F963B8E.9030105@kernel.org> <CAPa8GCA8q=S9sYx-0rDmecPxYkFs=gATGL-Dz0OYXDkwEECJkg@mail.gmail.com> <4F965413.9010305@kernel.org> <CAPa8GCCwfCFO6yxwUP5Qp9O1HGUqEU2BZrrf50w8TL9FH9vbrA@mail.gmail.com> <20120424143015.99fd8d4a.akpm@linux-foundation.org>
In-Reply-To: <20120424143015.99fd8d4a.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/04/25 6:30), Andrew Morton wrote:

> On Tue, 24 Apr 2012 17:48:29 +1000
> Nick Piggin <npiggin@gmail.com> wrote:
> 
>>> Hmm, there are several places to use GFP_NOIO and GFP_NOFS even, GFP_ATOMIC.
>>> I believe it's not trivial now.
>>
>> They're all buggy then. Unfortunately not through any real fault of their own.
> 
> There are gruesome problems in block/blk-throttle.c (thread "mempool,
> percpu, blkcg: fix percpu stat allocation and remove stats_lock").  It
> wants to do an alloc_percpu()->vmalloc() from the IO submission path,
> under GFP_NOIO.
> 
> Changing vmalloc() to take a gfp_t does make lots of sense, although I
> worry a bit about making vmalloc() easier to use!
> 
> I do wonder whether the whole scheme of explicitly passing a gfp_t was
> a mistake and that the allocation context should be part of the task
> context.  ie: pass the allocation mode via *current.  


yes...that's very interesting. 

Regards,
-Kame

