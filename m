Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946657Ab2LFS31 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 13:29:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42381 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946537Ab2LFS30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 13:29:26 -0500
Date: Thu, 6 Dec 2012 18:21:03 +0000
From: Mel Gorman <mgorman@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Henrik Rydberg <rydberg@euromail.se>,
        linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Oops in 3.7-rc8 isolate_free_pages_block()
Message-ID: <20121206182103.GD17258@suse.de>
References: <20121206091744.GA1397@polaris.bitmath.org>
 <20121206144821.GC18547@quack.suse.cz>
 <20121206161934.GA17258@suse.de>
 <CA+55aFw9WQN-MYFKzoGXF9Z70h1XsMu5X4hLy0GPJopBVuE=Yg@mail.gmail.com>
 <20121206175451.GC17258@suse.de>
 <CA+55aFwDZHXf2FkWugCy4DF+mPTjxvjZH87ydhE5cuFFcJ-dJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CA+55aFwDZHXf2FkWugCy4DF+mPTjxvjZH87ydhE5cuFFcJ-dJg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2012 at 10:19:35AM -0800, Linus Torvalds wrote:
> On Thu, Dec 6, 2012 at 9:55 AM, Mel Gorman <mgorman@suse.de> wrote:
> >
> > Yeah. I was listening to a talk while I was writing it, a bit cranky and
> > didn't see why I should suffer alone.
> 
> Makes sense.
> 
> > Quasimoto strikes again
> 
> Is that Quasimodo's Japanese cousin?
> 

Yes, he's tried to escape his terrible legacy with a name change.

> > -               end_pfn = min(pfn + pageblock_nr_pages, zone_end_pfn);
> > +
> > +               /*
> > +                * As pfn may not start aligned, pfn+pageblock_nr_page
> > +                * may cross a MAX_ORDER_NR_PAGES boundary and miss
> > +                * a pfn_valid check. Ensure isolate_freepages_block()
> > +                * only scans within a pageblock.
> > +                */
> > +               end_pfn = ALIGN(pfn + pageblock_nr_pages, pageblock_nr_pages);
> > +               end_pfn = min(end_pfn, end_pfn);
> 
> Ok, this looks much nicer, except it's obviously buggy. The
> min(end_pfn, end_pfn) thing is insane, and I'm sure you meant for that
> line to be
> 
> +               end_pfn = min(end_pfn, zone_end_pfn);
> 

*sigh* Yes, I did. Thanks.

-- 
Mel Gorman
SUSE Labs
