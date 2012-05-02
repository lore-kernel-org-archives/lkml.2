Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027Ab2EBJUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 05:20:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36144 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988Ab2EBJUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 05:20:34 -0400
Date: Wed, 2 May 2012 11:20:29 +0200
From: Jan Kara <jack@suse.cz>
To: Hugh Dickins <hughd@google.com>
Cc: Nick Piggin <npiggin@gmail.com>, mtk.manpages@gmail.com,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>, Jan Kara <jack@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>, linux-man@vger.kernel.org,
        linux-mm@kvack.org, mgorman@suse.de, Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] Describe race of direct read and fork for unaligned
 buffers
Message-ID: <20120502092029.GD16976@quack.suse.cz>
References: <1335778207-6511-1-git-send-email-jack@suse.cz>
 <CAHGf_=qqiast+6XzGnq+LRdFXoWG9h2MkofmjS1h5OeNPRyWfw@mail.gmail.com>
 <CAKgNAkjAOGM+mZLkXGiDFYsnMCpJsxx=Nd5pZfx-_f4B1jvh+A@mail.gmail.com>
 <CAPa8GCC7tHm_8Ks_=tM4x544+SEtkVk6TMAF3KPsVqzNOi-naA@mail.gmail.com>
 <alpine.LSU.2.00.1205011952040.1293@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1205011952040.1293@eggly.anvils>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 01-05-12 20:04:15, Hugh Dickins wrote:
> On Wed, 2 May 2012, Nick Piggin wrote:
> > On 2 May 2012 03:56, Michael Kerrisk (man-pages) <mtk.manpages@gmail.com> wrote:
> > >
> > > In the light of all of the comments, can someone revise the man-pages
> > > patch that Jan sent?
> > 
> > This does not quite describe the entire situation, but something understandable
> > to developers:
> > 
> > O_DIRECT IOs should never be run concurrently with fork(2) system call,
> > when the memory buffer is anonymous memory, or comes from mmap(2)
> > with MAP_PRIVATE.
> > 
> > Any such IOs, whether submitted with asynchronous IO interface or from
> > another thread in the process, should be quiesced before fork(2) is called.
> > Failure to do so can result in data corruption and undefined behavior in
> > parent and child processes.
> > 
> > This restriction does not apply when the memory buffer for the O_DIRECT
> > IOs comes from mmap(2) with MAP_SHARED or from shmat(2).
> 
> Nor does this restriction apply when the memory buffer has been advised
> as MADV_DONTFORK with madvise(2), ensuring that it will not be available
> to the child after fork(2).
  Yes, I think with this addition the text is fine.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
