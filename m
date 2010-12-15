Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab0LPC1a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 21:27:30 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:44499 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755189Ab0LPC1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 21:27:14 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAIYHCU15Lc+z/2dsb2JhbACkM3TBfIVKBA
Date: Wed, 15 Dec 2010 21:24:06 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Nick Piggin <npiggin@kernel.dk>, Eric Dumazet <eric.dumazet@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] fs: scale vfsmount refcount (was Re: rcu-walk and
  dcache scaling tree update and status)
Message-ID: <20101215102406.GB9093@amd>
References: <20101213023733.GB6522@amd>
 <20101213024217.GC6522@amd>
 <1292225113.18698.22.camel@edumazet-laptop>
 <20101214124059.GA14493@amd>
 <3E111710-7F88-41A8-80B2-9275448BBCED@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3E111710-7F88-41A8-80B2-9275448BBCED@dilger.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 01:16:52AM -0700, Andreas Dilger wrote:
> On 2010-12-14, at 05:40, Nick Piggin wrote:
> > +static inline void add_mnt_count(struct vfsmount *mnt, int n)
> > +static inline void set_mnt_count(struct vfsmount *mnt, int n)
> > +static inline void inc_mnt_count(struct vfsmount *mnt)
> > +static inline void dec_mnt_count(struct vfsmount *mnt)
> > +unsigned int count_mnt_count(struct vfsmount *mnt)
> 
> Minor nit - it is easier to find these related functions via tag
> completion if they are of the form "mnt_count_{add,set,inc,dec}"
> and it would also be more consistent and easier to understand if
> you rename count_mnt_count() to mnt_count_sum() or mnt_count_read().
> 
> This also follows the kernel naming convention much more closely
> (e.g. atomic_{inc,dec,add,sub,set,read}(), mutex_{init,lock,unlock}(),
> etc), which is normally of the form {type}_{action}.

OK, I agree.

 
> Yes, I see the other {inc,dec,count}_mnt_writers() functions
> exist, but I'd prefer not to add more bad function names to
> the kernel.  Maybe a separate patch to clean up those names is
> in order...

I might have added those too :P Yes they should be consistent, so
I'll rename them first.

Thanks,
Nick

