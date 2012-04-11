Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933036Ab2DKTZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 15:25:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55983 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760945Ab2DKTZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 15:25:56 -0400
Date: Wed, 11 Apr 2012 21:25:54 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Glauber Costa <glommer@parallels.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, devel@openvz.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        kamezawa.hiroyu@jp.fujitsu.com, Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] remove BUG() in possible but rare condition
Message-ID: <20120411192554.GC24831@tiehlicka.suse.cz>
References: <1334167824-19142-1-git-send-email-glommer@parallels.com>
 <20120411184845.GA24831@tiehlicka.suse.cz>
 <CA+55aFx1GMWGgh0sTAzvvVSzPQsQ_4NKeaNv1zpKrP4fg1dG+Q@mail.gmail.com>
 <4F85D53B.1070806@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F85D53B.1070806@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 11-04-12 16:02:19, Glauber Costa wrote:
> On 04/11/2012 03:57 PM, Linus Torvalds wrote:
> >On Wed, Apr 11, 2012 at 11:48 AM, Michal Hocko<mhocko@suse.cz>  wrote:
> >>
> >>I am not familiar with the code much but a trivial call chain walk up to
> >>write_dev_supers (in btrfs) shows that we do not check for the return value
> >>from __getblk so we would nullptr and there might be more.
> >>I guess these need some treat before the BUG might be removed, right?
> >
> >Well, realistically, isn't BUG() as bad as a NULL pointer dereference?
> >
> >Do you care about the exact message on the screen when your machine dies?
> Not particular, but I don't see why (I might be wrong) it would
> necessarily lead to a NULL pointer dereference.

Ahh, OK scratch that. I have misread __getblk_slow which returns NULL
only if grow_buffers returned with < 0 which doesn't happen for the
allocation failure.

Sorry about noise
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
