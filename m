Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932837Ab2IDWkg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 18:40:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757813Ab2IDWke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 18:40:34 -0400
Date: Wed, 5 Sep 2012 00:40:27 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Andi Kleen <ak@linux.intel.com>, Hugh Dickins <hughd@google.com>,
        Hillf Danton <dhillf@gmail.com>, linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [RFC v2 PATCH 0/7] thp: transparent hugepages on s390
Message-ID: <20120904224027.GM3334@redhat.com>
References: <1346254384-30046-1-git-send-email-gerald.schaefer@de.ibm.com>
 <20120830125444.86925ef3.akpm@linux-foundation.org>
 <20120831090757.2e29c834@de.ibm.com>
 <20120831124702.8980b637.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120831124702.8980b637.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew and Martin,

On Fri, Aug 31, 2012 at 12:47:02PM -0700, Andrew Morton wrote:
> On Fri, 31 Aug 2012 09:07:57 +0200
> Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> 
> > > I grabbed them all.  Patches 1-3 look sane to me and I cheerfully
> > > didn't read the s390 changes at all.  Hopefully Andrea will be able to
> > > review at least patches 1-3 for us.
> > > 
> > > If that all goes well, how do we play this?  I'd prefer to merge 1-3
> > > myself, as they do interact with ongoing MM development.  I can also
> > > merge 4-7 if appropriate s390 maintainer acks are seen.  Or I can drop
> > > them and the s390 parts can be merged via the s390 tree at a later
> > > date?
> > 
> > I would really appreciate if Andrea could have a look at the code.
> 
> Yes please ;)

:) Sorry for the delay! I was at the Plumbers until last Friday and
I'm catching up with the emails.

I finished reviewing them and they look perfectly fine. In fact it was
a pleasure to read them. Patch 1 and 2 are noops in x86 context, patch
3 is fine as well.

The s390 solution to send a dummy IPIs to wait gup-fast to exit the
critical section after setting the splitting bit looks fine as well.

The only additional code cleanup suggestion I can give is to also add
a HAVE_ARCH_TRANSPARENT_HUGEPAGE on the same lines of:

http://git.kernel.org/?p=linux/kernel/git/andrea/aa.git;a=commitdiff;h=36c2d096cce61fcfc1726ea1c1fd6dd65ddf8b08;hp=b2a86603629e2401d85f9ed1acbcf6c0043b2b23

as patch 8. In order to convert the below:

+       depends on (X86 || (S390 && 64BIT)) && MMU

to:

       depends on HAVE_ARCH_TRANSPARENT_HUGEPAGE

The MMU check looks already superflous, even more so after adding the
HAVE_ARCH_TRANSPARENT_HUGEPAGE (if something it'll be up to the arch
code to add a dependency on it before defining HAVE_ARCH_).

Thanks,
Andrea
