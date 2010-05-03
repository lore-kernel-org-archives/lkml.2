Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933246Ab0ECQjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 12:39:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59246 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759329Ab0ECQjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 12:39:23 -0400
Date: Mon, 3 May 2010 09:37:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
cc: akpm@linux-foundation.org, Mel Gorman <mel@csn.ul.ie>,
       Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 2/2] mm: fix race between shift_arg_pages and rmap_walk
In-Reply-To: <alpine.LFD.2.00.1005030928350.5478@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1005030935100.5478@i5.linux-foundation.org>
References: <20100503121743.653e5ecc@annuminas.surriel.com> <20100503121929.260ed5ee@annuminas.surriel.com> <alpine.LFD.2.00.1005030928350.5478@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 3 May 2010, Linus Torvalds wrote:
> 
> It looks like it makes execve() do a totally insane "create and then 
> immediately destroy temporary vma and anon_vma chain" for a case that is 
> unlikely to ever matter. 
> 
> In fact, for a case that isn't even normally _enabled_, namely migration.
> 
> Why would we want to slow down execve() for that?

Alternate suggestions:

 - clean up the patch so that it is explicitly abouy migration, and 
   doesn't even get enabled for anything else.

 - make the migration code take the VM lock for writing (why doesn't it 
   already?) and never race with things like this in the first place.

 - explain why the new code isn't any slower.

Hmm?

		Linus
