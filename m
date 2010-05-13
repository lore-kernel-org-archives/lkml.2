Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759176Ab0EMPpN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 11:45:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40795 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759131Ab0EMPpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 11:45:10 -0400
Date: Thu, 13 May 2010 08:43:35 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       stable@kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] vfs: Fix O_NOFOLLOW behavior for paths with trailing
 slashes
Message-Id: <20100513084335.7267bcf5.akpm@linux-foundation.org>
In-Reply-To: <20100513154135.GB21251@quack.suse.cz>
References: <1273747977-4579-1-git-send-email-jack@suse.cz>
	<alpine.LFD.2.00.1005130823370.3711@i5.linux-foundation.org>
	<20100513154135.GB21251@quack.suse.cz>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 May 2010 17:41:35 +0200 Jan Kara <jack@suse.cz> wrote:

> On Thu 13-05-10 08:24:59, Linus Torvalds wrote:
> > 
> > 
> > On Thu, 13 May 2010, Jan Kara wrote:
> > >
> > > According to specification
> > > mkdir d; ln -s d a; open("a/", O_NOFOLLOW | O_RDONLY)
> > > should return success but currently it did return ELOOP. Fix the code to ignore
> > > O_NOFOLLOW in case the provided path has trailing slashes. This is a regression
> > > caused by path lookup cleanup patch series.
> > > 
> > > CC: stable@kernel.org
> > 
> > Hmm? Is this correct? Isn't the bug introduced in this merge window, and 
> > thus not relevant for stable?
>   Ah, you're right! I've seen dates in the patches around December so I
> automatically thought the series went to 2.6.33 but checking git logs and
> the actual source code of 2.6.33 it went in later. I'm sorry for the
> confusion.

Yes, it's a bit tricky (for me, at least) to work out "which kernel version did
that patch go into" via git.

I just keep lots of kernel trees around and poke about with `patch
--dry-run'.  PITA.


