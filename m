Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933263Ab0ECQg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 12:36:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51418 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759063Ab0ECQg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 12:36:26 -0400
Date: Mon, 3 May 2010 09:34:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
cc: akpm@linux-foundation.org, Mel Gorman <mel@csn.ul.ie>,
       Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 2/2] mm: fix race between shift_arg_pages and rmap_walk
In-Reply-To: <20100503121929.260ed5ee@annuminas.surriel.com>
Message-ID: <alpine.LFD.2.00.1005030928350.5478@i5.linux-foundation.org>
References: <20100503121743.653e5ecc@annuminas.surriel.com> <20100503121929.260ed5ee@annuminas.surriel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 3 May 2010, Rik van Riel wrote:
> 
> migrate.c requires rmap to be able to find all ptes mapping a page at
> all times, otherwise the migration entry can be instantiated, but it
> can't be removed if the second rmap_walk fails to find the page.

Please correct me if I'm wrong, but this patch looks like pure and utter 
garbage.

It looks like it makes execve() do a totally insane "create and then 
immediately destroy temporary vma and anon_vma chain" for a case that is 
unlikely to ever matter. 

In fact, for a case that isn't even normally _enabled_, namely migration.

Why would we want to slow down execve() for that?

		Linus
