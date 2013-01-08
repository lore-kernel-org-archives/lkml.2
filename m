Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783Ab3AHR3s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 12:29:48 -0500
Received: from shutemov.name ([204.155.152.216]:37704 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755295Ab3AHR3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 12:29:47 -0500
Date: Tue, 8 Jan 2013 19:30:58 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hillf Danton <dhillf@gmail.com>, Hugh Dickins <hughd@google.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Linux-MM <linux-mm@kvack.org>,
        Rik van Riel <riel@redhat.com>
Subject: Re: oops in copy_page_rep()
Message-ID: <20130108173058.GA27727@shutemov.name>
References: <20130105152208.GA3386@redhat.com>
 <CAJd=RBCb0oheRnVCM4okVKFvKGzuLp9GpZJCkVY3RR-J=XEoBA@mail.gmail.com>
 <alpine.LNX.2.00.1301061037140.28950@eggly.anvils>
 <CAJd=RBAps4Qk9WLYbQhLkJd8d12NLV0CbjPYC6uqH_-L+Vu0VQ@mail.gmail.com>
 <CA+55aFyYAf6ztDLsxWFD+6jb++y0YNjso-9j+83Mm+3uQ=8PdA@mail.gmail.com>
 <CAJd=RBDTvCcYV8qAd-++_DOyDSypQD4Dvt216pG9nTQnWA2uCA@mail.gmail.com>
 <CA+55aFzfUABPycR82aNQhHNasQkL1kmxLN1rD0DJcByFtead3g@mail.gmail.com>
 <20130108163141.GA27555@shutemov.name>
 <CA+55aFzaTvF7nYxWBT-G_b=xGz+_akRAeJ=U9iHy+Y=ZPo=pbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzaTvF7nYxWBT-G_b=xGz+_akRAeJ=U9iHy+Y=ZPo=pbA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2013 at 08:52:14AM -0800, Linus Torvalds wrote:
> On Tue, Jan 8, 2013 at 8:31 AM, Kirill A. Shutemov <kirill@shutemov.name> wrote:
> >>
> >> Heh. I was more thinking about why do_huge_pmd_wp_page() needs it, but
> >> do_huge_pmd_numa_page() does not.
> >
> > It does. The check should be moved up.
> >
> >> Also, do we actually need it for huge_pmd_set_accessed()? The
> >> *placement* of that thing confuses me. And because it confuses me, I'd
> >> like to understand it.
> >
> > We need it for huge_pmd_set_accessed() too.
> >
> > Looks like a mis-merge. The original patch for huge_pmd_set_accessed() was
> > correct: http://lkml.org/lkml/2012/10/25/402
> 
> Not a merge error: the pmd_trans_splitting() check was removed by
> commit d10e63f29488 ("mm: numa: Create basic numa page hinting
> infrastructure").

Check difference between patch above and merged one -- a1dd450.
Merged patch is obviously broken: huge_pmd_set_accessed() can be called
only if the pmd is under splitting.

-- 
 Kirill A. Shutemov
