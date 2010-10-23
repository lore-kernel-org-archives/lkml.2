Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013Ab0JWQwl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 12:52:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:51787 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515Ab0JWQwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 12:52:40 -0400
Date: Sat, 23 Oct 2010 09:53:13 -0700
From: Greg KH <gregkh@suse.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        "Dr. Werner Fink" <werner@suse.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 28/49] tty: Add a new file /proc/tty/consoles
Message-ID: <20101023165313.GC20684@suse.de>
References: <20101022175112.GC13489@kroah.com> <1287771688-14805-28-git-send-email-gregkh@suse.de> <4CC2C9A8.1040003@suse.cz> <20101023115129.GM19804@ZenIV.linux.org.uk> <4CC2CE66.7010405@suse.cz> <20101023122612.GO19804@ZenIV.linux.org.uk> <20101023154636.GA18786@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101023154636.GA18786@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 23, 2010 at 08:46:36AM -0700, Greg KH wrote:
> On Sat, Oct 23, 2010 at 01:26:12PM +0100, Al Viro wrote:
> > On Sat, Oct 23, 2010 at 02:00:38PM +0200, Jiri Slaby wrote:
> > 
> > > > Please, don't.  Even leaving aside the fact that it's mind-bogglingly
> > > > broken (->private_data can be _ANYTHING_, including arbitrary number cast
> > > > to pointer), you really shouldn't screw your way through the descriptor
> > > > table in the first place.
> > > > 
> > > > Strongly NACKed.
> > > 
> > > Well, our complains are -ETOOLATE -- it's commit f4a3e0bceb57466c
> > > upstream. So please fix this up.
> > 
> > FVO "fix" equal to "revert".  Belated review:
> > 
> > a) global variable depending on stdin of the last opener?  Affecting
> > output of read(2)?  Really?
> > 
> > b) iterator is broken; list should be locked in ->start(), unlocked
> > in ->stop() and *NOT* unlocked/relocked in ->next()
> > 
> > c) ->show() ought to do nothing in case of ->device == NULL, instead
> > of skipping those in ->next()/->start()
> > 
> > d) regardless of the merits of the bright idea about asterisk at that
> > line in output *and* regardless of (a), the implementation is not only
> > atrociously ugly, it's actually very likely to be a roothole.  Verifying
> > that Cthulhu knows what number happens to be address of a tty_struct by
> > blindly dereferencing memory at that address...  Ouch.
> > 
> > Please revert that crap.
> 
> I'll revert it and send the pull request to Linus.

Odd:
	> git revert f4a3e0bceb57466c
	Finished one revert.
	# On branch master
	nothing to commit (working directory clean)

Um, what just happened, I don't seem to be able to revert this patch.
Did something change with git revert recently?  I'm using:
	> git --version
	git version 1.7.2

Any ideas?

greg k-h
