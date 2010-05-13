Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309Ab0EMQBE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 12:01:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54550 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932150Ab0EMQBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 12:01:00 -0400
Date: Thu, 13 May 2010 08:58:49 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, stable@kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] vfs: Fix O_NOFOLLOW behavior for paths with trailing
 slashes
In-Reply-To: <20100513084335.7267bcf5.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1005130846170.3711@i5.linux-foundation.org>
References: <1273747977-4579-1-git-send-email-jack@suse.cz> <alpine.LFD.2.00.1005130823370.3711@i5.linux-foundation.org> <20100513154135.GB21251@quack.suse.cz> <20100513084335.7267bcf5.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 13 May 2010, Andrew Morton wrote:
>
> >   Ah, you're right! I've seen dates in the patches around December so I
> > automatically thought the series went to 2.6.33 but checking git logs and
> > the actual source code of 2.6.33 it went in later. I'm sorry for the
> > confusion.
> 
> Yes, it's a bit tricky (for me, at least) to work out "which kernel version did
> that patch go into" via git.
> 
> I just keep lots of kernel trees around and poke about with `patch
> --dry-run'.  PITA.

What I did to double-check was:

	git log fs/namei.c

to find the commit series by Al (obviously, you can do it other ways too, 
but that was the easy way). Then, when you find the commit  just do

	git name-rev 1f36f774b22a0ceb7dd33eca626746c81a97b6a5

which gives us

	1f36f774b22a0ceb7dd33eca626746c81a97b6a5 tags/v2.6.34-rc1~195^2

ie that commit is reachable from v2.6.34-rc1, not from any stable kernel.

(Or alternatively, use "git describe", and get "v2.6.33-5088-g1f36f77", 
which means that it is v2.6.33 plus 5088 commits).

And as usual, there are other ways. One particularly obscure one is to say

	git log --tags --source --author=viro fs/namei.c

which basically says "show only commits by viro in fs/namei.c, start from 
all tags, and for each commit, show _which_ tag the commit was reached 
from". It's not perfect, but it does it in one go. With "--oneline", you'd 
have gotten a listing like

	3e297b6 v2.6.34-rc3 Restore LOOKUP_DIRECTORY hint handling in final lookup on open()
	781b167 v2.6.34-rc2 Fix a dumb typo - use of & instead of &&
	1f36f77 v2.6.34-rc2 Switch !O_CREAT case to use of do_last()
	def4af3 v2.6.34-rc2 Get rid of symlink body copying
	3866248 v2.6.34-rc2 Finish pulling of -ESTALE handling to upper level in do_filp_open()
	806b681 v2.6.34-rc2 Turn do_link spaghetty into a normal loop
	10fa8e6 v2.6.34-rc2 Unify exits in O_CREAT handling
	9e67f36 v2.6.34-rc2 Kill is_link argument of do_last()
	...

so you see into which -rc the different patches from Al went.

			Linus
