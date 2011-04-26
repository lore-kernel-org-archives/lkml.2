Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151Ab1DZFCr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 01:02:47 -0400
Received: from 1wt.eu ([62.212.114.60]:34900 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554Ab1DZFCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 01:02:45 -0400
Date: Tue, 26 Apr 2011 07:01:48 +0200
From: Willy Tarreau <w@1wt.eu>
To: Hugh Dickins <hughd@google.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        Bob Liu <lliubbo@gmail.com>, David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Enrik Berkhan <Enrik.Berkhan@ge.com>
Subject: Re: [PATCH 165/173] ramfs: fix memleak on no-mmu arch
Message-ID: <20110426050148.GB14259@1wt.eu>
References: <20110425200240.164070671@pcw.home.local> <alpine.LSU.2.00.1104251653310.5571@sister.anvils>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1104251653310.5571@sister.anvils>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 05:37:19PM -0700, Hugh Dickins wrote:
(...)
> >  fs/ramfs/file-nommu.c |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > --- a/fs/ramfs/file-nommu.c
> > +++ b/fs/ramfs/file-nommu.c
> > @@ -111,6 +111,7 @@ int ramfs_nommu_expand_for_mapping(struc
> >  		SetPageDirty(page);
> >  
> >  		unlock_page(page);
> > +		put_page(page);
> >  	}
> >  
> >  	return 0;
> 
> 
> I'm not absolutely certain, but I rather think this patch should NOT
> be included: I never looked to see when the bug it fixes crept in,
> but now I'm thinking it may have been 2678958e1225 "ramfs-nommu:
> use generic lru cache", which did not go in until 2.6.30 -
> __lru_cache_add adding the unbalanced page_cache_get.

OK.

> Whereas the "SetPageDirty" you can see above is not in 2.6.27.59-rc1:

Ah indeed you're right !

> I think you'd do well to include the patch below which introduced it.
> (It may give you a reject because __pagevec_lru_add was enhanced to
> __pagevec_lru_add_file by the time that patch went in.)
> 
> Yes, the pages Enrik reports as being wrongly discarded, would not
> have been discarded if their reference counts were too high:
> I do believe you need Enrik's patch instead of Bob's patch.

Fine, I will do that then.
Thank you Hugh for the detailed explanation !

Willy

