Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932999Ab2DKTU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 15:20:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55663 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756034Ab2DKTU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 15:20:56 -0400
Date: Wed, 11 Apr 2012 21:20:52 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        devel@openvz.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>, kamezawa.hiroyu@jp.fujitsu.com,
        Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] remove BUG() in possible but rare condition
Message-ID: <20120411192052.GB24831@tiehlicka.suse.cz>
References: <1334167824-19142-1-git-send-email-glommer@parallels.com>
 <20120411184845.GA24831@tiehlicka.suse.cz>
 <CA+55aFx1GMWGgh0sTAzvvVSzPQsQ_4NKeaNv1zpKrP4fg1dG+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFx1GMWGgh0sTAzvvVSzPQsQ_4NKeaNv1zpKrP4fg1dG+Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 11-04-12 11:57:56, Linus Torvalds wrote:
> On Wed, Apr 11, 2012 at 11:48 AM, Michal Hocko <mhocko@suse.cz> wrote:
> >
> > I am not familiar with the code much but a trivial call chain walk up to
> > write_dev_supers (in btrfs) shows that we do not check for the return value
> > from __getblk so we would nullptr and there might be more.
> > I guess these need some treat before the BUG might be removed, right?
> 
> Well, realistically, isn't BUG() as bad as a NULL pointer dereference?
> 
> Do you care about the exact message on the screen when your machine dies?

I personally do not care as I do not allow anything to map at that area.

It just seems that there are some callers who do not expect that the
allocation fails. BUG at the allocation failure which dates back when it
replaced buffer_error might have let to some assumptions (not good of
course but we should better fix them.

That being said I am not against the patch. BUG on an allocation failure
just doesn't feel right...

> 
>                      Linus
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
