Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab2JCCsO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 22:48:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43849 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab2JCCsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 22:48:13 -0400
Date: Wed, 3 Oct 2012 03:48:11 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] vfs, part 1
Message-ID: <20121003024811.GO13973@ZenIV.linux.org.uk>
References: <20121003013936.GN13973@ZenIV.linux.org.uk>
 <CA+55aFwot+bbm_L93kqCfLDEuQUSdWK=cRdDG-W7=O4zEh96RQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwot+bbm_L93kqCfLDEuQUSdWK=cRdDG-W7=O4zEh96RQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 07:31:58PM -0700, Linus Torvalds wrote:
> On Tue, Oct 2, 2012 at 6:39 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >         This is *not* all; fs/dcache.c bits will go separately, for one
> > thing - that's just the first pile.  Please, pull from the usual place -
> 
> Al, *please* describe what is going on. Your description is negative
> (what *doesn't* happen in this pull) and does not at all describe what
> is going on.

Umm...  OK, but it won't be particulary pretty:
	* big one - consolidation of descriptor-related logics; almost all
of that is moved to fs/file.c (BTW, I'm seriously tempted to rename the
result to fd.c.  As it is, we have a situation when file_table.c is about
handling of struct file and file.c is about handling of descriptor tables;
the reasons are historical - file_table.c used to be about a static array
of struct file we used to have way back).   A lot of stray ends got cleaned
up and converted to saner primitives, disgusting mess in android/binder.c
is still disgusting, but at least doesn't poke so much in descriptor table
guts anymore.  A bunch of relatively minor races got fixed in process,
plus an ext4 struct file leak.
	* related thing - fget_light() partially unuglified; see fdget()
in there (and yes, it generates the code as good as we used to have).
	* also related - bits of Cyrill's procfs stuff that got entangled
into that work; _not_ all of it, just the initial move to fs/proc/fd.c
and switch of fdinfo to seq_file.
	* Alex's fs/coredump.c spiltoff - the same story, had been easier to
take that commit than mess with conflicts.  The rest is a separate pile, this
was just a mechanical code movement.
	* a few misc patches all over the place.  Not all for this cycle,
there'll be more (and quite a few currently sit in akpm's tree).
