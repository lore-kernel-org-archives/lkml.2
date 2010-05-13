Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759215Ab0EMPvr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 11:51:47 -0400
Received: from cantor.suse.de ([195.135.220.2]:51165 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756364Ab0EMPvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 11:51:46 -0400
Date: Thu, 13 May 2010 17:51:39 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       stable@kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] vfs: Fix O_NOFOLLOW behavior for paths with trailing
 slashes
Message-ID: <20100513155138.GC21251@quack.suse.cz>
References: <1273747977-4579-1-git-send-email-jack@suse.cz>
 <alpine.LFD.2.00.1005130823370.3711@i5.linux-foundation.org>
 <20100513154135.GB21251@quack.suse.cz>
 <20100513084335.7267bcf5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100513084335.7267bcf5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 13-05-10 08:43:35, Andrew Morton wrote:
> On Thu, 13 May 2010 17:41:35 +0200 Jan Kara <jack@suse.cz> wrote:
> 
> > On Thu 13-05-10 08:24:59, Linus Torvalds wrote:
> > > 
> > > 
> > > On Thu, 13 May 2010, Jan Kara wrote:
> > > >
> > > > According to specification
> > > > mkdir d; ln -s d a; open("a/", O_NOFOLLOW | O_RDONLY)
> > > > should return success but currently it did return ELOOP. Fix the code to ignore
> > > > O_NOFOLLOW in case the provided path has trailing slashes. This is a regression
> > > > caused by path lookup cleanup patch series.
> > > > 
> > > > CC: stable@kernel.org
> > > 
> > > Hmm? Is this correct? Isn't the bug introduced in this merge window, and 
> > > thus not relevant for stable?
> >   Ah, you're right! I've seen dates in the patches around December so I
> > automatically thought the series went to 2.6.33 but checking git logs and
> > the actual source code of 2.6.33 it went in later. I'm sorry for the
> > confusion.
> 
> Yes, it's a bit tricky (for me, at least) to work out "which kernel version did
> that patch go into" via git.
  Well, if you know the commit id, "git describe --contains <commit-id>"
tells what you need. But sometimes I'm too lazy to use "git describe" and
sometimes I forget "--contains" which then returns the kernel version on
which the patch was based - not quite what I'm interested in...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
