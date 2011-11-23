Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab1KWNXf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 08:23:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31140 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755408Ab1KWNXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 08:23:34 -0500
Date: Wed, 23 Nov 2011 14:25:56 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH v2 1/3] mm: more intensive memory corruption debug
Message-ID: <20111123132555.GB7943@redhat.com>
References: <1321633507-13614-1-git-send-email-sgruszka@redhat.com>
 <20111122135608.42686f14.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111122135608.42686f14.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 01:56:08PM -0800, Andrew Morton wrote:
> On Fri, 18 Nov 2011 17:25:05 +0100
> Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> I added this:
> 
>   The default value of debug_guardpage_minorder is zero: no change
>   from current behaviour.
> 
> correct?
Yes,

> > +static inline void clear_page_guard_flg(struct page *page)
> > +{
> > +	__clear_bit(PAGE_DEBUG_FLAG_GUARD, &page->debug_flags);
> > +}
> 
> Why is it safe to use the non-atomic bitops here.
Clearing/setting flag is done only in __free_one_page()/expand(),
so operations are protected by zone->lock.

> Please verify that CONFIG_WANT_PAGE_DEBUG_FLAGS is always reliably
> enabled when this feature is turned on.
Change in mm/Kconfig.debug assures that CONFIG_WANT_PAGE_DEBUG_FLAGS is
set whenever CONFIG_DEBUG_PAGEALLOC is. 

> Some changes I made - please review.
Look good, thanks Andrew!

Stanislaw
