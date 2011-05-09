Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab1EIWpP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 18:45:15 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:49846 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932123Ab1EIWpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 18:45:13 -0400
Date: Mon, 9 May 2011 16:45:11 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        Hugh Dickins <hughd@google.com>, Oleg Nesterov <oleg@redhat.com>,
        agk@redhat.com
Subject: Re: [PATCH] Don't mlock guardpage if the stack is growing up
Message-ID: <20110509224511.GC15227@parisc-linux.org>
References: <alpine.DEB.2.00.1105082045250.15552@artax.karlin.mff.cuni.cz> <BANLkTikEpaRZK3X4YReeQAwgcv3HAGUwSw@mail.gmail.com> <alpine.DEB.2.00.1105091246550.32299@artax.karlin.mff.cuni.cz> <4DC7D37F.9040308@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DC7D37F.9040308@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 09, 2011 at 01:43:59PM +0200, Zdenek Kabelac wrote:
> > Why it doesn't use mlockall()? Because glibc maps all locales to the 
> > process. Glibc packs all locales to a 100MB file and maps that file to 
> > every process. Even if the process uses just one locale, glibc maps all.
> > 
> > So, when LVM used mlockall, it consumed >100MB memory and it caused 
> > out-of-memory problems in system installers.
> > 
> > So, alternate way of locking was added to LVM --- read all maps and lock 
> > them, except for the glibc locale file.
> > 
> > The real fix would be to fix glibc not to map 100MB to every process.
> 
> I should add here probably few words.
> 
> Glibc knows few more ways around - so it could work only with one locale file
> per language, or even without using mmap and allocating them in memory.
> Depends on the distribution usually - Fedora decided to combine all locales
> into one huge file (>100MB) - Ubuntu/Debian mmaps each locales individually
> (usually ~MB)

Sounds to me like glibc should introduce an mlockmost() call that does all
the work for you ...

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
