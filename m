Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761658Ab2EJVwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 17:52:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761180Ab2EJVwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 17:52:16 -0400
Date: Thu, 10 May 2012 17:52:09 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tejun@google.com, agk@redhat.com
Subject: Re: [dm-devel] [Bcache v13 02/16] Bio pool freeing
Message-ID: <20120510215208.GC2613@redhat.com>
References: <cover.1336619038.git.koverstreet@google.com>
 <ba8ce9fcca87f192ff5f5d3a436eb8f4d0bcb006.1336619038.git.koverstreet@google.com>
 <20120510213217.GN23768@redhat.com>
 <CAH+dOxL7QwcyUm46cK-pF1qK+kHYC=67iAaQDDwUF2ssJwergA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH+dOxL7QwcyUm46cK-pF1qK+kHYC=67iAaQDDwUF2ssJwergA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 02:39:26PM -0700, Kent Overstreet wrote:
> On Thu, May 10, 2012 at 2:32 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Wed, May 09, 2012 at 11:08:34PM -0400, Kent Overstreet wrote:
> >> When you allocate a bio from a bio pool, to free it you have to know
> >> where it came from; this adds a flag which, if set, means bi_destructor
> >> is the pointer to the pool and bio_put() can do the right thing.
> >>
> >> This is used in bcache, so we can cleanly use per device bio pools.
> >
> > Ok, that will explain BIO_HAS_POOL flag.  Why to replace
> > bio_has_allocated_vec() with BIO_HAS_VEC flag?
> 
> Using bio_has_allocated_vec() would mean the bvec would always be
> freed if it wasn't a pointer to the inline vecs - my bio splitting
> code will use the bvec from the original bio for the split if it's
> splitting on a bvec boundary, in which case that's not what we want.
> 
> It means "bio owns its bvec".

ok, probably we could explain it more in changelog or push this in same
patch where you introduce bio splitting so that bio shares bvec with other
bio. That way it is easier to understand.

Thanks
Vivek
