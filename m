Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab0ECRDY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 13:03:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753791Ab0ECRDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 13:03:22 -0400
Date: Mon, 3 May 2010 19:02:30 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, Mel Gorman <mel@csn.ul.ie>,
       Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 1/2] mm: Take all anon_vma locks in anon_vma_lock
Message-ID: <20100503170230.GF19891@random.random>
References: <20100503121743.653e5ecc@annuminas.surriel.com>
 <20100503121847.7997d280@annuminas.surriel.com>
 <1272905712.1642.150.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272905712.1642.150.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 03, 2010 at 06:55:12PM +0200, Peter Zijlstra wrote:
> This does leave me worrying about concurrent faults poking at
> vma->vm_end without synchronization.

I didn't check this patch in detail yet. I agree it can be removed and
I think it can be safely replaced with the page_table_lock.
