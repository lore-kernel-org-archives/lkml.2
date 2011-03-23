Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933197Ab1CWXQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 19:16:27 -0400
Received: from kroah.org ([198.145.64.141]:60501 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933166Ab1CWXQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 19:16:25 -0400
Date: Wed, 23 Mar 2011 15:58:53 -0700
From: Greg KH <greg@kroah.com>
To: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org
Subject: Re: [stable] [PATCH] mm: PageBuddy and mapcount underflows robustness
Message-ID: <20110323225853.GH27334@kroah.com>
References: <alpine.LSU.2.00.1103140059510.1661@sister.anvils>
 <20110314155232.GB10696@random.random>
 <alpine.LSU.2.00.1103140910570.2601@sister.anvils>
 <20110314165922.GE10696@random.random>
 <AANLkTikWh5tFUZuALYRP3Dx2Zcs33u0UVdjf4d_7KhPJ@mail.gmail.com>
 <20110317231635.GC10696@random.random>
 <alpine.LSU.2.00.1103181428100.1996@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1103181428100.1996@sister.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 02:34:03PM -0700, Hugh Dickins wrote:
> On Fri, 18 Mar 2011, Andrea Arcangeli wrote:
> > On Mon, Mar 14, 2011 at 10:30:11AM -0700, Linus Torvalds wrote:
> > Subject: mm: PageBuddy and mapcount robustness
> > 
> > From: Andrea Arcangeli <aarcange@redhat.com>
> > 
> > Change the _mapcount value indicating PageBuddy from -2 to -128 for
> > more robusteness against page_mapcount() undeflows.
> > 
> > Use reset_page_mapcount instead of __ClearPageBuddy in bad_page to
> > ignore the previous retval of PageBuddy().
> > 
> > Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> > Reported-by: Hugh Dickins <hughd@google.com>
> 
> Yes, this version satisfies my objections too.
> I'd say Acked-by but I see that it's already in, great.
> 
> I've Cc'ed stable@kernel.org: please can we have this in 2.6.38.1,
> since 2.6.38 regressed the recovery from bad page states,
> inadvertently changing them to a fatal error when CONFIG_DEBUG_VM.

Now queued up for 2.6.38.2, thanks.

greg k-h
