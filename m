Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932554Ab0E0Ru7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 13:50:59 -0400
Received: from gir.skynet.ie ([193.1.99.77]:35847 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759402Ab0E0Ru5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 13:50:57 -0400
Date: Thu, 27 May 2010 18:50:38 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Rik van Riel <riel@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [PATCH 5/5] extend KSM refcounts to the anon_vma root
Message-ID: <20100527175038.GB10931@csn.ul.ie>
References: <20100526153819.6e5cec0d@annuminas.surriel.com> <20100526154124.04607d04@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100526154124.04607d04@annuminas.surriel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 03:41:24PM -0400, Rik van Riel wrote:
> Subject: extend KSM refcounts to the anon_vma root
> 
> KSM reference counts can cause an anon_vma to exist after the processe
> it belongs to have already exited.  Because the anon_vma lock now lives
> in the root anon_vma, we need to ensure that the root anon_vma stays
> around until after all the "child" anon_vmas have been freed.
> 
> The obvious way to do this is to have a "child" anon_vma take a
> reference to the root in anon_vma_fork.  When the anon_vma is freed
> at munmap or process exit, we drop the refcount in anon_vma_unlink
> and possibly free the root anon_vma.
> 
> The KSM anon_vma reference count function also needs to be modified
> to deal with the possibility of freeing 2 levels of anon_vma.  The
> easiest way to do this is to break out the KSM magic and make it
> generic.
> 
> When compiling without CONFIG_KSM, this code is compiled out.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>

Acked-by: Mel Gorman <mel@csn.ul.ie>

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
