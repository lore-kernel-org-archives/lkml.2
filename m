Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204Ab0DNXVB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 19:21:01 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:47325 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755297Ab0DNXVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 19:21:00 -0400
Date: Thu, 15 Apr 2010 01:20:40 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Rik van Riel <riel@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: [PATCH] rmap: add exclusively owned pages to the newest anon_vma
Message-ID: <20100414232040.GA31097@cmpxchg.org>
References: <20100411185508.GA4450@liondog.tnic> <alpine.LFD.2.00.1004111707360.3514@i5.linux-foundation.org> <alpine.LFD.2.00.1004111759440.3521@i5.linux-foundation.org> <20100412072056.GA2432@liondog.tnic> <alpine.LFD.2.00.1004120854440.26679@i5.linux-foundation.org> <alpine.LFD.2.00.1004120906370.26679@i5.linux-foundation.org> <20100412215027.GA6263@liondog.tnic> <alpine.LFD.2.00.1004121508290.3647@i5.linux-foundation.org> <20100413093827.GA6954@liondog.tnic> <20100414175928.5e1bdce2@annuminas.surriel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100414175928.5e1bdce2@annuminas.surriel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 05:59:28PM -0400, Rik van Riel wrote:
> The recent anon_vma fixes cause many anonymous pages to end up
> in the parent process anon_vma, even when the page is exclusively
> owned by the current process.
> 
> Adding exclusively owned anonymous pages to the top anon_vma
> reduces rmap scanning overhead, especially in workloads with
> forking servers.
> 
> This patch adds a parameter to __page_set_anon_rmap that can
> be used to indicate whether or not the added page is exclusively
> owned by the current process.
> 
> Pages added through page_add_new_anon_rmap are exclusively
> owned by the current process, and can be added to the top
> anon_vma.
> 
> Pages added through page_add_anon_rmap can be either shared
> or exclusively owned, so we do the conservative thing and
> add it to the oldest anon_vma.
> 
> A next step would be to add the exclusive parameter to
> page_add_anon_rmap, to be used from functions where we do
> know for sure whether a page is exclusively owned.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
