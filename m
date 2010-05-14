Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab0ENChm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 22:37:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:24456 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932105Ab0ENChl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 22:37:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,226,1272870000"; 
   d="scan'208";a="517807146"
Date: Fri, 14 May 2010 10:37:37 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] radix-tree: fix radix_tree_prev_hole underflow case
Message-ID: <20100514023737.GB8695@localhost>
References: <1273802724-3414-1-git-send-email-cesarb@cesarb.net>
 <20100514021508.GA7810@localhost>
 <4BECB562.2080200@cesarb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BECB562.2080200@cesarb.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 10:28:50AM +0800, Cesar Eduardo Barros wrote:
> Em 13-05-2010 23:15, Wu Fengguang escreveu:
> > On Fri, May 14, 2010 at 10:05:24AM +0800, Cesar Eduardo Barros wrote:
> >> radix_tree_prev_hole() used LONG_MAX to detect underflow; however,
> >> ULONG_MAX is clearly what was intended, both here and by its only user
> >> (count_history_pages at mm/readahead.c).
> >
> > Good catch, thanks! I actually have a more smart
> > radix_tree_prev_hole() that uses ULONG_MAX.
> 
> I saw it already ([PATCH 14/16] radixtree: speed up the search for 
> hole), but it misses the LONG_MAX in the documentation comment.

Yes, thanks!

> > Andrew, fortunately this bug has little impact on readahead.
> 
> I agree, if I read it correctly it should only have any impact either 
> when very near LONG_MAX or in the unlikely case that there is no hole at 
> ULONG_MAX. And even then, the impact should be limited.

Right.
