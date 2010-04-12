Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab0DLTtz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 15:49:55 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53725 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab0DLTtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 15:49:53 -0400
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the
 anon_vmas of a mergeable VMA
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Borislav Petkov <bp@alien8.de>,
       Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
In-Reply-To: <1271100621.20295.3397.camel@laptop>
References: <20100409191425.GB10780@a1.tnic>
	 <alpine.LFD.2.00.1004091227310.3558@i5.linux-foundation.org>
	 <20100409204328.GG28964@cmpxchg.org>
	 <alpine.LFD.2.00.1004091546350.3558@i5.linux-foundation.org>
	 <alpine.LFD.2.00.1004091638290.3558@i5.linux-foundation.org>
	 <20100410003110.GI28964@cmpxchg.org>
	 <alpine.LFD.2.00.1004091730130.3558@i5.linux-foundation.org>
	 <20100410072714.GA9246@liondog.tnic> <20100410112639.GA24708@a1.tnic>
	 <alpine.LFD.2.00.1004100821340.3558@i5.linux-foundation.org>
	 <20100410163828.GA25579@a1.tnic>
	 <alpine.LFD.2.00.1004100947400.3558@i5.linux-foundation.org>
	 <alpine.LFD.2.00.1004101101180.3558@i5.linux-foundation.org>
	 <1271083207.4807.18.camel@twins>  <4BC33A02.8000307@redhat.com>
	 <1271088103.20295.3383.camel@laptop> <4BC34501.5060401@redhat.com>
	 <alpine.LFD.2.00.1004120941310.26679@i5.linux-foundation.org>
	 <1271097638.4807.129.camel@twins>  <1271100621.20295.3397.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Apr 2010 21:44:34 +0200
Message-ID: <1271101474.20295.3400.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-12 at 21:30 +0200, Peter Zijlstra wrote:
> 
> We could here return a non-valid and already freed anon_vma.
> 
OK, so non of the users of page_lock_anon_vma() with exception of the
memory-failure.c one could really care. And all of them seem to be safe
enough wrt dealing with a dead one.

So unless people care, I'm going to not spend more time on trying to
make page_lock_anon_vma() behave.

Instead I'll try and see wth it is that migrate.c and rmap_walk_anon are
doing.

