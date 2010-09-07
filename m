Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914Ab0IGIhc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 04:37:32 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64988 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755709Ab0IGIh2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 04:37:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=apsYcAqbhucze7SPI2x6xqWklkVMz2dgWjj0hn6f3GloTKWEjcskgD+b/z4dxMM44B
         LrNV6QcK0EYX6Hf4JKcudZUsMia0a6GNcGjd5kedhbOtd7QG4jwmSkHO/LXw6azo/Kd8
         yka9vMHcfhxj4tPwHkmm3Itm8F5jfpjL+XKNw=
MIME-Version: 1.0
In-Reply-To: <20100907114505.fc40ea3d.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100907114505.fc40ea3d.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 7 Sep 2010 01:37:27 -0700
Message-ID: <AANLkTintQqzx50Jp_zyKQMaAfhSEFah3HhseNmNfNMjB@mail.gmail.com>
Subject: Re: [RFC][PATCH] big continuous memory allocator v2
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mel Gorman <mel@csn.ul.ie>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nice cleanup.
There are some comments in below.

On Mon, Sep 6, 2010 at 7:45 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
> This is a page allcoator based on memory migration/hotplug code.
> passed some small tests, and maybe easier to read than previous one.
>
> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> This patch as a memory allocator for contiguous memory larger than MAX_ORDER.
>
>  alloc_contig_pages(hint, size, node);

I have thought this patch is to be good for dumb device drivers which
want big contiguous
memory. So if some device driver want big memory and they can tolerate
latency or fail,
this is good solution, I think.
And some device driver can't tolerate fail, they have to use MOVABLE zone.

For it, I hope we have a option like ALLOC_FIXED(like MAP_FIXED).
That's because embedded people wanted to aware BANK of memory.
So if they get free page which they don't want, it can be pointless.

In addition, I hope it can support CROSS_ZONE migration mode.
Most of small system can't support swap system. So if we can't migrate
anon pages into other zones, external fragment problem still happens.

I think reclaim(ex, discard file-backed pages) can become one option to prevent
the problem. But it's more cost so we can support it by calling mode.
(But it could be trivial since caller should know this function is very cost)

ex) alloc_contig_pages(hint, size, node, ALLOC_FIXED|ALLOC_RECLAIM);


Thanks, Kame.



-- 
Kind regards,
Minchan Kim
