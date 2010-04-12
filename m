Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab0DLRHR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 13:07:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34703 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750827Ab0DLRHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 13:07:15 -0400
Date: Mon, 12 Apr 2010 10:03:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
cc: Thomas Gleixner <tglx@linutronix.de>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: LOCALVERSION_AUTO considered harmful
In-Reply-To: <20100412131405.GB22773@ucw.cz>
Message-ID: <alpine.LFD.2.00.1004121000400.26679@i5.linux-foundation.org>
References: <20100411164701.GA7558@elf.ucw.cz> <20100412185136.GA13171@x200> <g2v10f740e81004111158r4d4714a1w23b8521d5d595b29@mail.gmail.com> <20100411201426.GC25294@elf.ucw.cz> <alpine.LFD.2.00.1004120022230.18009@localhost.localdomain>
 <20100412131405.GB22773@ucw.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 12 Apr 2010, Pavel Machek wrote:

> Hi!
> 
> > > > > That's conditional BS.
> > > > > Turn off CONFIG_MODVERSIONS already.
> > > > 
> > > > Yeah, I disabled it ages ago. Even then (before git, probably even
> > > > before bitkeeper)
> > > > I had hard times inserting modules...
> > > 
> > > I _had_ it off
> > > 
> > >  # CONFIG_MODVERSIONS is not set
> > > 
> > > It seems some checking survives CONFIG_MODVERSIONS unset and that
> > > checking is strict enough to refuse module load after one "make
> > > modules" with LOCALVERSION_AUTO on...
> > 
> > So instead of fixing the CONFIG_MODVERSIONS=n case you go the easy way
> > of killing LOCALVERSION_AUTO ? Brilliant.
> 
> In previous discussion, I was told that there's no bug to fix, that
> everything works as intended.

The problem is that you guys are looking at CONFIG_MODVERSIONS the wrong 
way around.

It's the _off_ case that is broken. Always was, always will be.

If CONFIG_MODVERSIONS is off, we remove the symbol versioning, and replace 
it with the _insane_ kernel version check. That is never valid. The fact 
that the kernel version is the same doesn't mean that the module will 
work, since we often do lots of changes within the same version.

So the solution is to say CONFIG_MODVERSIONS=y, and everybody is happy. 
Your modules will actually test things that _matter_, and will stop 
loading if the data types or function prototypes have changed. 

		Linus
