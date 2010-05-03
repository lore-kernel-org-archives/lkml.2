Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab0ECRLY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 13:11:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:54338 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab0ECRLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 13:11:22 -0400
Subject: Re: [PATCH 1/2] mm: Take all anon_vma locks in anon_vma_lock
From: Peter Zijlstra <peterz@infradead.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, Mel Gorman <mel@csn.ul.ie>,
       Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux.com>
In-Reply-To: <20100503170230.GF19891@random.random>
References: <20100503121743.653e5ecc@annuminas.surriel.com>
	 <20100503121847.7997d280@annuminas.surriel.com>
	 <1272905712.1642.150.camel@laptop>  <20100503170230.GF19891@random.random>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 May 2010 19:11:19 +0200
Message-ID: <1272906679.1642.152.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-03 at 19:02 +0200, Andrea Arcangeli wrote:
> On Mon, May 03, 2010 at 06:55:12PM +0200, Peter Zijlstra wrote:
> > This does leave me worrying about concurrent faults poking at
> > vma->vm_end without synchronization.
> 
> I didn't check this patch in detail yet. I agree it can be removed and
> I think it can be safely replaced with the page_table_lock.

Sure, it could probably be replaced with the ptl, but a single
anon_vma->lock would I think be better since there's more of them.



