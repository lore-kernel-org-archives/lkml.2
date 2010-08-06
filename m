Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761740Ab0HFSKq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 14:10:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46766 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751136Ab0HFSKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 14:10:44 -0400
MIME-Version: 1.0
In-Reply-To: <20100806175217.GA8944@merkur.ravnborg.org>
References: <20100804125156.GA23464@sepie.suse.cz> <AANLkTi=hYsksUJUsrETjFouLDiKhwQHgD2oQ7XLyrOC-@mail.gmail.com> 
	<4C5B64EA.2000804@gmail.com> <AANLkTikpsvpHuB-mWVfmqTRRMvbvhJz2LmoYBgtn4NQE@mail.gmail.com> 
	<20100806051354.GA24343@merkur.ravnborg.org> <4C5BE229.1090801@suse.cz> 
	<AANLkTimWHnxbYzkJ1KhuS3DgTuSRz-gMnzEJvbsY835g@mail.gmail.com> 
	<20100806175217.GA8944@merkur.ravnborg.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 6 Aug 2010 11:09:41 -0700
Message-ID: <AANLkTimkngSrDFUcHOySkf22yY3Qr3p+m2qnwDzre+zk@mail.gmail.com>
Subject: Re: [PATCH] kconfig: fix make oldconfig
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>,
        "Justin P. Mattock" <justinmattock@gmail.com>, JBeulich@novell.com,
        aris@redhat.com, catalin.marinas@arm.com, jacmet@sunsite.dk,
        lizf@cn.fujitsu.com, ulfalizer.lkml@gmail.com, zippel@linux-m68k.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 6, 2010 at 10:52 AM, Sam Ravnborg <sam@ravnborg.org> wrote:
>
> Hmm, I wonder why you call oldconfig explicitly?
>
> A plain "make -j16" executes "silentoldconfig" if there
> is any changes in a Kconfig* file or in .config.
> Just double checked and it works as I expected.
>
> So you are asked if there is any new options anyway even
> if you skip your "oldconfig" step.

Try this:

   git clean -dqfx
   make -j16 > ../makes

It doesn't work, because "make silentconfig" will say

  ***
  *** You have not yet configured your kernel!
  *** (missing kernel config file ".config")
  ***
  *** Please run some configurator (e.g. "make oldconfig" or
  *** "make menuconfig" or "make xconfig").
  ***

which is why I always run "make oldconfig".

Sure, I could do it only when I need to, but quite frankly, it's much
easier to just always do the thing that works, rather than try
something that doesn't work, do something else, and then re-try the
thing that can fail.

                     Linus
