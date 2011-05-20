Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933639Ab1ETHus (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 03:50:48 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53719 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932489Ab1ETHur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 03:50:47 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 20 May 2011 16:43:54 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Andrew Lutomirski <luto@mit.edu>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        fengguang.wu@intel.com, andi@firstfloor.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, hannes@cmpxchg.org,
        riel@redhat.com
Subject: Re: Kernel falls apart under light memory pressure (i.e. linking
 vmlinux)
Message-Id: <20110520164354.d43be406.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <BANLkTinJbYrQoye7qjPzPxP8_deCSK0g7w@mail.gmail.com>
References: <BANLkTikhj1C7+HXP_4T-VnJzPefU2d7b3A@mail.gmail.com>
	<20110514165346.GV6008@one.firstfloor.org>
	<BANLkTik6SS9NH7XVSRBoCR16_5veY0MKBw@mail.gmail.com>
	<20110514174333.GW6008@one.firstfloor.org>
	<BANLkTinst+Ryox9VZ-s7gdXKa574XXqt5w@mail.gmail.com>
	<20110515152747.GA25905@localhost>
	<BANLkTim-AnEeL=z1sYm=iN7sMnG0+m0SHw@mail.gmail.com>
	<20110517060001.GC24069@localhost>
	<BANLkTi=TOm3aLQCD6j=4va6B+Jn2nSfwAg@mail.gmail.com>
	<BANLkTi=9W6-JXi94rZfTtTpAt3VUiY5fNw@mail.gmail.com>
	<BANLkTikHMUru=w4zzRmosrg2bDbsFWrkTQ@mail.gmail.com>
	<BANLkTima0hPrPwe_x06afAh+zTi-bOcRMg@mail.gmail.com>
	<BANLkTi=NTLn4Lx7EkybuA8-diTVOvMDxBw@mail.gmail.com>
	<BANLkTinEDXHuRUYpYN0d95+fz4+F7ccL4w@mail.gmail.com>
	<4DD5DC06.6010204@jp.fujitsu.com>
	<BANLkTik=7C5qFZTsPQG4JYY-MEWDTHdc6A@mail.gmail.com>
	<BANLkTins7qxWVh0bEwtk1Vx+m98N=oYVtw@mail.gmail.com>
	<20110520140856.fdf4d1c8.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTinJbYrQoye7qjPzPxP8_deCSK0g7w@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 May 2011 14:36:13 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> On Fri, May 20, 2011 at 2:08 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > On Fri, 20 May 2011 13:20:15 +0900
> > Minchan Kim <minchan.kim@gmail.com> wrote:
> >
> >> So I want to resolve your problem asap.
> >> We don't have see report about that. Could you do git-bisect?
> >> FYI, Recently, big change of mm is compaction,transparent huge pages.
> >> Kame, could you point out thing related to memcg if you have a mind?
> >>
> >
> > I don't doubt memcg at this stage because it never modify page->flags.
> > Consdering the case, PageActive() is set against off-LRU pages after
> > clear_active_flags() clears it.
> >
> > Hmm, I think I don't understand the lock system fully but...how do you
> > think this ?
> >
> > ==
> >
> > At splitting a hugepage, the routine marks all pmd as "splitting".
> >
> > But assume a racy case where 2 threads run into spit at the
> > same time, one thread wins compound_lock() and do split, another
> > thread should not touch splitted pages.
> 
> Sorry. Now I don't have a time to review in detail.
> When I look it roughly,  page_lock_anon_vma have to prevent it.
> But Andrea needs current this problem and he will catch something we lost. :)
> 
Hmm, maybe I miss something...need to build a test environ on my side.
But I'm not sure I can reproduce it..

Thanks,
-Kame

