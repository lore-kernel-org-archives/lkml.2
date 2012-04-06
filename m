Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758310Ab2DFXKd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 19:10:33 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33219 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383Ab2DFXKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 19:10:32 -0400
Date: Fri, 6 Apr 2012 16:10:13 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Chris Metcalf <cmetcalf@tilera.com>, Hillf Danton <dhillf@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH v2] hugetlb: fix race condition in hugetlb_fault()
In-Reply-To: <20120406152305.59408e35.akpm@linux-foundation.org>
Message-ID: <alpine.LSU.2.00.1204061601370.3637@eggly.anvils>
References: <201203302018.q2UKIFH5020745@farm-0012.internal.tilera.com> <CAJd=RBCoLNB+iRX1shKGAwSbE8PsZXyk9e3inPTREcm2kk3nXA@mail.gmail.com> <201203311339.q2VDdJMD006254@farm-0012.internal.tilera.com> <CAJd=RBBWx7uZcw=_oA06RVunPAGeFcJ7LY=RwFCyB_BreJb_kg@mail.gmail.com>
 <4F7887A5.3060700@tilera.com> <20120406152305.59408e35.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Apr 2012, Andrew Morton wrote:
> On Sun, 1 Apr 2012 12:51:49 -0400
> Chris Metcalf <cmetcalf@tilera.com> wrote:
> 
> > >> Cc: stable@kernel.org
> > > Let Andrew do the stable work, ok?
> > 
> > Fair point.  I'm used to adding the Cc myself for things I push through the
> > arch/tile tree.  This of course does make more sense to go through Andrew,
> > so I'll remove it.
> 
> No, please do add the stable tag if you think it is needed.  And ensure
> that the changelog explains why a backport is needed, by describing
> the user-visible effects of the bug.
> 
> Tree-owners regularly forget to wonder if a patch should be backported
> and we end up failing to backport patches which should have been
> backported.  If we have more people flagging backport patches, fewer
> patches will fall through the cracks.

The resulting patch is okay; but let's reassure Chris that his
original patch was better, before he conceded to make the get_page
and put_page unconditional, and added unnecessary detail of the race.

Hugh
