Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760118Ab2EKOKY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 10:10:24 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46837 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760096Ab2EKOKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 10:10:21 -0400
Date: Fri, 11 May 2012 07:10:01 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Minchan Kim <minchan@kernel.org>
cc: Sasha Levin <levinsasha928@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: raise MemFree by reverting percpu_pagelist_fraction
 to 0
In-Reply-To: <4FACD00D.4060003@kernel.org>
Message-ID: <alpine.LSU.2.00.1205110656540.5839@eggly.anvils>
References: <alpine.LSU.2.00.1205110054520.2801@eggly.anvils> <CA+1xoqcChazS=TRt6-7GjJAzQNFLFXmO623rWwjRkdD5x3k=iw@mail.gmail.com> <4FACD00D.4060003@kernel.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2012, Minchan Kim wrote:
> On 05/11/2012 05:30 PM, Sasha Levin wrote:
> 
> >> Commit 93278814d359 "mm: fix division by 0 in percpu_pagelist_fraction()"
> >> mistakenly initialized percpu_pagelist_fraction to the sysctl's minimum 8,
> >> which leaves 1/8th of memory on percpu lists (on each cpu??); but most of
> >> us expect it to be left unset at 0 (and it's not then used as a divisor).
> > 
> > I'm a bit confused about this, does it mean that once you set
> > percpu_pagelist_fraction to a value above the minimum, you can no
> > longer set it back to being 0?
> 
> 
> Unfortunately, Yes. :(
> It's rather awkward and need fix.

It's inelegant, but does that actually need a fix?  Has anybody asked
for that option in the six years of percpu_pagelist_fraction?

Does setting percpu_pagelist_fraction to some large number perhaps
approximate to the default behaviour of percpu_pagelist_fraction 0?

I don't care very much either way - just don't want this discussion
to divert from applying last night's fix to the default behaviour
that most people expect.

Hugh
