Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933430Ab2DKV02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 17:26:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33500 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933381Ab2DKV01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 17:26:27 -0400
Date: Wed, 11 Apr 2012 23:26:22 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        devel@openvz.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>, kamezawa.hiroyu@jp.fujitsu.com,
        Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] remove BUG() in possible but rare condition
Message-ID: <20120411212621.GD24831@tiehlicka.suse.cz>
References: <1334167824-19142-1-git-send-email-glommer@parallels.com>
 <20120411132635.bfddc6bd.akpm@linux-foundation.org>
 <4F85EEED.1090906@parallels.com>
 <20120411141244.2839d9a8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120411141244.2839d9a8.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 11-04-12 14:12:44, Andrew Morton wrote:
> On Wed, 11 Apr 2012 17:51:57 -0300
> Glauber Costa <glommer@parallels.com> wrote:
> 
> > On 04/11/2012 05:26 PM, Andrew Morton wrote:
> > >>
> > >> >    failed:
> > >> >  -	BUG();
> > >> >    	unlock_page(page);
> > >> >    	page_cache_release(page);
> > >> >    	return NULL;
> > > Cute.
> > >
> > > AFAICT what happened was that in my April 2002 rewrite of this code I
> > > put a non-fatal buffer_error() warning in that case to tell us that
> > > something bad happened.
> > >
> > > Years later we removed the temporary buffer_error() and mistakenly
> > > replaced that warning with a BUG().  Only it*can*  happen.
> > >
> > > We can remove the BUG() and fix up callers, or we can pass retry=1 into
> > > alloc_page_buffers(), so grow_dev_page() "cannot fail".  Immortal
> > > functions are a silly fiction, so we should remove the BUG() and fix up
> > > callers.
> > >
> > Any particular caller you are concerned with ?
> 
> Didn't someone see a buggy caller in btrfs?

No I missed that __getblk (__getblk_slow) returns NULL only if
grow_buffers < 0 while it returns 0 for the allocation failure.

Sorry for confusion.
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
