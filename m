Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab1FCSNf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 14:13:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963Ab1FCSNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 14:13:34 -0400
Date: Fri, 3 Jun 2011 20:13:22 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Hugh Dickins <hughd@google.com>
Cc: Chris Wright <chrisw@sous-sol.org>, Andrea Righi <andrea@betterlinux.com>,
        CAI Qian <caiqian@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG 3.0.0-rc1] ksm: NULL pointer dereference in ksm_do_scan()
Message-ID: <20110603181322.GN2802@random.random>
References: <20110601222032.GA2858@thinkpad>
 <2144269697.363041.1306998593180.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
 <20110602141927.GA2011@thinkpad>
 <20110602164841.GK23047@sequoia.sous-sol.org>
 <alpine.LSU.2.00.1106021011300.1277@sister.anvils>
 <20110602174305.GH19505@random.random>
 <alpine.LSU.2.00.1106030957090.1901@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1106030957090.1901@sister.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 03, 2011 at 10:06:14AM -0700, Hugh Dickins wrote:
> On Thu, 2 Jun 2011, Andrea Arcangeli wrote:
> > On Thu, Jun 02, 2011 at 10:29:39AM -0700, Hugh Dickins wrote:
> > > AndreaA, I didn't study the patch you posted half an hour ago,
> > > since by that time I'd worked it out and was preparing patch below.
> > > I think your patch would be for a different bug, hopefully one we
> > > don't have, it looks more complicated than we should need for this.
> > 
> > I didn't expect two different bugs leading to double free.
> 
> There wasn't a double free there, just failure to cope with race
> emptying the list, so accessing head when expecting a full entry.

Yes, we thought it was a double free initially because of two dead
pointers but we couldn't explain why mm was null so consistently.

> You'll see from the "beware" comment in scan_get_next_rmap_item()
> that this case is expected, that it sometimes reaches freeing the
> slots before the exiting task reaches __ksm_exit().
> 
> That race should already be handled.  I believe your patch is unnecessary,
> because get_mm_slot() is a hashlist lookup, and will return NULL once
> either end has done the hlist_del(&mm_slot->link).

Ok so that case is handled by get_mm_slot not succeeding. I see thanks
for the review.
