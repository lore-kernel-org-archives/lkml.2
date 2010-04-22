Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829Ab0DVVNu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 17:13:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45313 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757801Ab0DVVNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 17:13:46 -0400
Date: Fri, 23 Apr 2010 07:13:35 +1000
From: Neil Brown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: tip: origin tree build failure (x86, 32-bit, allyesconfig)
Message-ID: <20100423071335.50a8a341@notabene.brown>
In-Reply-To: <alpine.LFD.2.00.1004221111220.26046@i5.linux-foundation.org>
References: <19350.53522.385933.467438@notabene.brown>
	<20100422070610.GA18884@elte.hu>
	<alpine.LFD.2.00.1004221111220.26046@i5.linux-foundation.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Apr 2010 11:12:41 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Thu, 22 Apr 2010, Ingo Molnar wrote:
> > 
> > All 32-bit x86 builds (x86, allyesconfig) that enable RAID are failing with 
> > this build failure:
> > 
> >  drivers/built-in.o: In function `raid5_compute_sector':
> >  raid5.c:(.text+0x2e42ac): undefined reference to `__umoddi3'
> >  raid5.c:(.text+0x2e42d8): undefined reference to `__umoddi3'
> >  raid5.c:(.text+0x2e42ff): undefined reference to `__umoddi3'
> >  raid5.c:(.text+0x2e4327): undefined reference to `__umoddi3'
> >  raid5.c:(.text+0x2e4385): undefined reference to `__umoddi3'
> >  drivers/built-in.o:raid5.c:(.text+0x2e43bc): more undefined references to `__umoddi3' follow
> > 
> > Caused by this commit:
> > 
> >   35f2a59: md/raid5: allow for more than 2^31 chunks.
> 
> Gaah, yes.
> 
> How about just making it "unsigned long" instead of sector_t, and telling 
> people that if they have more than 2**32 chunks in their RAID array, they 
> should damn well use a 64-bit CPU.
> 
> The alternative, of course, is to use "sector_div()" everywhere. Neil?

Sorry, using sector_div everywhere is definitely the right thing to do.
Please pull one more patch from

  git://neil.brown.name/md/ for-linus

Thanks,
NeilBrown
