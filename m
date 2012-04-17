Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab2DQRGR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 13:06:17 -0400
Received: from fieldses.org ([174.143.236.118]:49342 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754140Ab2DQRGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 13:06:16 -0400
Date: Tue, 17 Apr 2012 13:06:14 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] vfs and fs fixes
Message-ID: <20120417170614.GA29994@fieldses.org>
References: <20120417052511.GU6589@ZenIV.linux.org.uk>
 <CA+55aFw75=Mtq1njQ9vNmNsGuTPbpUhLHnb7YBLmCZs4Q5ByMA@mail.gmail.com>
 <20120417162216.GB27426@fieldses.org>
 <CA+55aFzTKt43-qm4se2ac24kEVQO=aH8sckh0e-Lf-wydnYHfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFzTKt43-qm4se2ac24kEVQO=aH8sckh0e-Lf-wydnYHfg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 09:33:06AM -0700, Linus Torvalds wrote:
> On Tue, Apr 17, 2012 at 9:22 AM, J. Bruce Fields <bfields@fieldses.org> wrote:
> >
> > Ugh, no, I think you're right:
> >
> >        rename A/a->A/b
> >        rename B/b->B/b
> >
> > where A/a and B/a are the same file, and A/b and B/b are the same file,
> > can result in the first rename holding the lock on A and a and waiting
> > on b, and the second holding the lock on B and b and waiting on a.
> 
> In fact I don't think you need even that much. Just a simple
> 
>   touch a
>   ln a b
>   mv a b
> 
> looks like it should deadlock on itself, no? source and dest inodes
> will be the same, so the mutex_lock() will just deadlock without even
> any ABBA race.
> 
> (I didn't really check - maybe there is some reason that doesn't happen).

Yeah, rename has that funny exception that makes the above a no-op, so I
think that's safe.

But the patch is still wrong; back to the drawing board.

Maybe a paper bag over my head will help my concentration....

--b.
