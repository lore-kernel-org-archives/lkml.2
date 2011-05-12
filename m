Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459Ab1ELP1H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 11:27:07 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:23644 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756064Ab1ELP1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 11:27:06 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: zOZ.gc8VM1nS3t.xhUTYbdhTdbFYacjlW51ejx_OinrnKXA
 HfSE47s5_3eHEBjoOBYiTHJsT4zBN6Qx35Za7hz2U4f7T6OK1F38DqXawtFP
 GqlsUh7gT2n7gjxoZeHDKJYtP9HgPbLFbRiWijt6_.cc3jEQig6_5.gv1E5p
 IGJvM.xiXDtho9wo3iRkTnkEhdgKpzmmX.QJ166RJ1AHcdWrrOUAA8DQU4o6
 iYfffDzgf3r2hedqtQn6LATSv0PTEc36P4GS9W5zflE7rwL4bHh15lvwSwsR
 S7.64.fEnT.I1oz7NvnaTnqJSMF.t0serepRTj0umYmmRKX7_
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 12 May 2011 10:27:00 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Colin King <colin.king@canonical.com>,
        Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
        Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
        Pekka Enberg <penberg@kernel.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 3/3] mm: slub: Default slub_max_order to 0
In-Reply-To: <1305213359.2575.46.camel@mulgrave.site>
Message-ID: <alpine.DEB.2.00.1105121024350.26013@router.home>
References: <1305127773-10570-1-git-send-email-mgorman@suse.de>  <1305127773-10570-4-git-send-email-mgorman@suse.de>  <alpine.DEB.2.00.1105120942050.24560@router.home> <1305213359.2575.46.camel@mulgrave.site>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 May 2011, James Bottomley wrote:

> > >   */
> > >  static int slub_min_order;
> > > -static int slub_max_order = PAGE_ALLOC_COSTLY_ORDER;
> > > +static int slub_max_order;
> >
> > If we really need to do this then do not push this down to zero please.
> > SLAB uses order 1 for the meax. Lets at least keep it theere.
>
> 1 is the current value.  Reducing it to zero seems to fix the kswapd
> induced hangs.  The problem does look to be some shrinker/allocator
> interference somewhere in vmscan.c, but the fact is that it's triggered
> by SLUB and not SLAB.  I really think that what's happening is some type
> of feedback loops where one of the shrinkers is issuing a
> wakeup_kswapd() so kswapd never sleeps (and never relinquishes the CPU
> on non-preempt).

The current value is PAGE_ALLOC_COSTLY_ORDER which is 3.

> > We have been using SLUB for a long time. Why is this issue arising now?
> > Due to compaction etc making reclaim less efficient?
>
> This is the snark argument (I've said it thrice the bellman cried and
> what I tell you three times is true).  The fact is that no enterprise
> distribution at all uses SLUB.  It's only recently that the desktop
> distributions started to ... the bugs are showing up under FC15 beta,
> which is the first fedora distribution to enable it.  I'd say we're only
> just beginning widespread SLUB testing.

Debian and Ubuntu have been using SLUB for a long time (and AFAICT from my
archives so has Fedora). I have been running those here for a couple of
years and the issues that I see here seem to be only with the most
recent kernels that now do compaction and other reclaim tricks.





