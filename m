Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab0E0BCc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 21:02:32 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35240 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab0E0BCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 21:02:30 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 27 May 2010 09:57:47 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Mel Gorman <mel@csn.ul.ie>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [PATCH 4/5] always lock the root (oldest) anon_vma
Message-Id: <20100527095747.e32a0598.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100526154044.2769e707@annuminas.surriel.com>
References: <20100526153819.6e5cec0d@annuminas.surriel.com>
	<20100526154044.2769e707@annuminas.surriel.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010 15:40:44 -0400
Rik van Riel <riel@redhat.com> wrote:

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

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>



