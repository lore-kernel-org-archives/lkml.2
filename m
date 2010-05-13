Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759012Ab0EMPlo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 11:41:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50346 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545Ab0EMPlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 11:41:42 -0400
Date: Thu, 13 May 2010 17:41:35 +0200
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] vfs: Fix O_NOFOLLOW behavior for paths with trailing
 slashes
Message-ID: <20100513154135.GB21251@quack.suse.cz>
References: <1273747977-4579-1-git-send-email-jack@suse.cz>
 <alpine.LFD.2.00.1005130823370.3711@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005130823370.3711@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 13-05-10 08:24:59, Linus Torvalds wrote:
> 
> 
> On Thu, 13 May 2010, Jan Kara wrote:
> >
> > According to specification
> > mkdir d; ln -s d a; open("a/", O_NOFOLLOW | O_RDONLY)
> > should return success but currently it did return ELOOP. Fix the code to ignore
> > O_NOFOLLOW in case the provided path has trailing slashes. This is a regression
> > caused by path lookup cleanup patch series.
> > 
> > CC: stable@kernel.org
> 
> Hmm? Is this correct? Isn't the bug introduced in this merge window, and 
> thus not relevant for stable?
  Ah, you're right! I've seen dates in the patches around December so I
automatically thought the series went to 2.6.33 but checking git logs and
the actual source code of 2.6.33 it went in later. I'm sorry for the
confusion.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
