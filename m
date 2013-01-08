Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844Ab3AHSEf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 13:04:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756574Ab3AHSEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 13:04:34 -0500
Date: Tue, 8 Jan 2013 19:03:46 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, Hugh Dickins <hughd@google.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Linux-MM <linux-mm@kvack.org>,
        Rik van Riel <riel@redhat.com>
Subject: Re: oops in copy_page_rep()
Message-ID: <20130108180346.GH9163@redhat.com>
References: <CAJd=RBCb0oheRnVCM4okVKFvKGzuLp9GpZJCkVY3RR-J=XEoBA@mail.gmail.com>
 <alpine.LNX.2.00.1301061037140.28950@eggly.anvils>
 <CAJd=RBAps4Qk9WLYbQhLkJd8d12NLV0CbjPYC6uqH_-L+Vu0VQ@mail.gmail.com>
 <CA+55aFyYAf6ztDLsxWFD+6jb++y0YNjso-9j+83Mm+3uQ=8PdA@mail.gmail.com>
 <CAJd=RBDTvCcYV8qAd-++_DOyDSypQD4Dvt216pG9nTQnWA2uCA@mail.gmail.com>
 <CA+55aFzfUABPycR82aNQhHNasQkL1kmxLN1rD0DJcByFtead3g@mail.gmail.com>
 <20130108163141.GA27555@shutemov.name>
 <CA+55aFzaTvF7nYxWBT-G_b=xGz+_akRAeJ=U9iHy+Y=ZPo=pbA@mail.gmail.com>
 <20130108173747.GF9163@redhat.com>
 <CA+55aFyG26N3_KiA8_cxLW59xFMJBK8SKfG4qL80NMQ3tdh3Nw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyG26N3_KiA8_cxLW59xFMJBK8SKfG4qL80NMQ3tdh3Nw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2013 at 09:51:47AM -0800, Linus Torvalds wrote:
> On Tue, Jan 8, 2013 at 9:37 AM, Andrea Arcangeli <aarcange@redhat.com> wrote:
> >
> > The reason it returned to userland and retried the fault is that this
> > should be infrequent enough not to worry about it and this was
> > marginally simpler but it could be changed.
> 
> Yeah, that was my suspicion. And as mentioned, returning to user land
> might actually help with scheduling and/or signal handling latencies
> etc, so it might be the right thing to do.  Especially if the
> alternative is to just busy-loop.
> 
> > If we don't want to return to userland we should wait on the splitting
> > bit and then take the pte walking routines like if the pmd wasn't
> > huge. This is not related to the below though.
> 
> How does this patch sound to people? It does the splitting check
> before the access bit set (even though I don't think it matters), and
> at least talks about the alternatives and the issues a bit.
> 
> Hmm?

It looks very fine to me, but I suggest to move it above the
pmd_numa() check because of the newly introduced
migrate_misplaced_transhuge_page method relying on pmd_same too.

Thanks!
