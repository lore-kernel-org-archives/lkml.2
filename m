Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab0E0NzS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 09:55:18 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:56543 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725Ab0E0NzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 09:55:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fV83fTVwEsr0CJnULMDquVozKF6CQZVZ2btgCkK+QuXIyXgEywN4OTTMNWWrrhWC4h
         c+oAMn6tgFC+nhecFfdI7TrMeWqLSQc1kSE/lT2hLgyCWaRMYiQ5CaRIKWNOkiCI7ZpO
         HafvnTuWzajycT7gu/E45WbZC2i+Re2sXoTNU=
Date: Thu, 27 May 2010 22:55:07 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Mel Gorman <mel@csn.ul.ie>,
       Andrea Arcangeli <aarcange@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [PATCH 4/5] always lock the root (oldest) anon_vma
Message-ID: <20100527135356.GD2112@barrios-desktop>
References: <20100526153819.6e5cec0d@annuminas.surriel.com>
 <20100526154044.2769e707@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100526154044.2769e707@annuminas.surriel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 03:40:44PM -0400, Rik van Riel wrote:
> Subject: always lock the root (oldest) anon_vma
> 
> Always (and only) lock the root (oldest) anon_vma whenever we do something in an
> anon_vma.  The recently introduced anon_vma scalability is due to the rmap code
> scanning only the VMAs that need to be scanned.  Many common operations still
> took the anon_vma lock on the root anon_vma, so always taking that lock is not
> expected to introduce any scalability issues.
> 
> However, always taking the same lock does mean we only need to take one lock,
> which means rmap_walk on pages from any anon_vma in the vma is excluded from
> occurring during an munmap, expand_stack or other operation that needs to
> exclude rmap_walk and similar functions.
> 
> Also add the proper locking to vma_adjust.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Nitpick:

It would be better to modify comment about head of anon_vma in rmap.h, too.
/*  
 * NOTE: the LSB of the head.next is set by
                   ->   root->hext.next 
-- 
Kind regards,
Minchan Kim
