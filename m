Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab2ECGr2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 02:47:28 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42018 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158Ab2ECGr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 02:47:27 -0400
Date: Thu, 3 May 2012 07:47:22 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@gmail.com>, Jana Saout <jana@saout.de>,
        Joel Becker <jlbec@evilplan.org>, linux-kernel@vger.kernel.org
Subject: Re: Oops with DCACHE_WORD_ACCESS and ocfs2, autofs4
Message-ID: <20120503064722.GN6871@ZenIV.linux.org.uk>
References: <1335788867.29087.19.camel@localhost>
 <20120501110024.GC6649@dhcp-172-17-9-228.mtv.corp.google.com>
 <1335875321.26671.15.camel@localhost>
 <CAPa8GCANv=-c7HsYvDqM+8JqJq6Gr9muxAivU2Ni16x9Ru5EXw@mail.gmail.com>
 <CA+55aFwPgWqCPA=ao6XmZy56PaJZ4WC+hOZ_CHGWpo_zO425VA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwPgWqCPA=ao6XmZy56PaJZ4WC+hOZ_CHGWpo_zO425VA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 10:57:00PM -0700, Linus Torvalds wrote:

> There are multiple ways to fix this, including just marking that
> unaligned word access as being able to take an exception, but I had
> hoped to avoid having to do that. There are alternatives, like always
> padding allocations up by 7 bytes, but those are nasty too. So I'd
> like to understand what triggers this for Jana, it's possible we can
> just work around that particular issue.

What I'd really like to know is whether we can hit the same kind of "steps
off the end of page" crap on pagecache based symlinks with very long bodies.
The upper limit is 4K, which allows that sucker to reach the end of page
on most of the architectures.  And that can be done on just about any fs
supporting symlinks at all - create a symlink with the long body (up to the
limit), something like (("./"x2047)."a"). 
