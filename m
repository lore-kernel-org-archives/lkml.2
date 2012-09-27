Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab2I0BgS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 21:36:18 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:62931 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab2I0BgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 21:36:16 -0400
X-AuditID: 9c930179-b7bf9ae000000e4c-87-5063ad7e04eb
Date: Thu, 27 Sep 2012 10:39:12 +0900
From: Minchan Kim <minchan@kernel.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] zsmalloc: promote to lib/
Message-ID: <20120927013912.GB10229@bbox>
References: <1348649419-16494-1-git-send-email-minchan@kernel.org>
 <1348649419-16494-2-git-send-email-minchan@kernel.org>
 <CAOJsxLGjp5PAgPe3KSvMfqJEyVC4YHeP+FW3AmnCorpHqnfang@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLGjp5PAgPe3KSvMfqJEyVC4YHeP+FW3AmnCorpHqnfang@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka,

On Wed, Sep 26, 2012 at 12:51:49PM +0300, Pekka Enberg wrote:
> On Wed, Sep 26, 2012 at 11:50 AM, Minchan Kim <minchan@kernel.org> wrote:
> >  lib/Kconfig                              |    2 +
> >  lib/Makefile                             |    1 +
> >  lib/zsmalloc/Kconfig                     |   18 +
> >  lib/zsmalloc/Makefile                    |    1 +
> >  lib/zsmalloc/zsmalloc.c                  | 1064 ++++++++++++++++++++++++++++++
> 
> What's wrong with mm/zsmalloc.c?

Why I put zsmalloc into under mm firstly is that Andrew had a concern
about using strut page's some fields freely in zsmalloc so he wanted
to maintain it in mm/ if I remember correctly.

So I and Nitin tried to ask the opinion to akpm several times
(at least 5 and even I sent such patch a few month ago) but didn't get
any reply from him so I guess he doesn't have any concern about that
any more.

In point of view that it's an another slab-like allocator,
it might be proper under mm but it's not popular as current mm's 
allocators(/SLUB/SLOB and page allocator).

Frankly speaking, I'm okay whether we put it to mm/ or lib/.
But it seems Nitin and Konrad like lib/ and Andrew is silent.
That's why I am biased into lib/ now.

If someone yell we should keep it to mm/ by logical claim,
I can change my mind easily.
But I've never heard abut that until now.

> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
