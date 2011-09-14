Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492Ab1INWIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 18:08:19 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46687 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab1INWIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 18:08:18 -0400
Subject: Re: [BUG] infinite loop in find_get_pages()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: Shaohua Li <shaohua.li@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Lin Ming <mlin@ss.pku.edu.cn>,
        Justin Piszcz <jpiszcz@lucidpixels.com>, Pawel Sikora <pluto@agmk.net>
In-Reply-To: <alpine.LSU.2.00.1109141427190.29355@sister.anvils>
References: <1315941801.2565.19.camel@edumazet-laptop>
	 <CA+55aFyG3-3_gqGjqUmsTAHWfmNLMdQVf4XqUZrDAGMBxgur=Q@mail.gmail.com>
	 <CA+55aFz9DFFJyjMusVkUcBdCBX02RrmH0uCRASw0EQHC3SdaUA@mail.gmail.com>
	 <1315983230.2565.28.camel@edumazet-laptop>
	 <CANejiEXK524dgYZ+TSfqytZHE9CLjtP70cmvTPSNPR5zeDYkxw@mail.gmail.com>
	 <CANejiEUe+uhsUMxc43cL7Y+vU=bV0pVx13N5LuS4r27YSKTZ-w@mail.gmail.com>
	 <1315989783.2361.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <1315990519.29510.119.camel@sli10-conroe>
	 <alpine.LSU.2.00.1109141337080.29178@sister.anvils>
	 <1316033750.2835.2.camel@edumazet-laptop>
	 <alpine.LSU.2.00.1109141427190.29355@sister.anvils>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Sep 2011 00:08:09 +0200
Message-ID: <1316038089.2835.4.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 14 septembre 2011 à 14:53 -0700, Hugh Dickins a écrit :
> On Wed, 14 Sep 2011, Eric Dumazet wrote:
> > Le mercredi 14 septembre 2011 à 13:38 -0700, Hugh Dickins a écrit :
> > > 
> > > I'd like to think about that a little more before finalizing the
> > > patch below - does it work, and does it look acceptable so far?
> > > Of course, the mods to truncate.c and vmscan.c are not essential
> > > parts of this fix, just things to tidy up while on the subject.
> > > Right now I must attend to some other stuff, will return tomorrow.
> > 
> > Hello Hugh
> > 
> > I am going to test this ASAP,
> 
> Thanks, Eric, though it may not be worth spending your time on it.
> It occurred to me over lunch that it may take painfully longer than
> expected to invalidate_mapping_pages() on a single-swapped-out-page
> 1TB sparse tmpfs file - all those "start += 1" restarts until it
> reaches the end.
> 
> I might decide to leave invalidate_mapping_pages() giving up early
> (unsatisfying, but no worse than before), and convert scan_mapping_
> unevictable_pages() (which is used on nothing but shmem) to pass
> index vector to radix_tree_gang_whatever().
> 
> Dunno, I'll think about it more later.
> 

I tested your patch as is on my machine, and everything seems fine.

I let the stress continue while I am going to sleep :)

See you


