Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261Ab1B1Cp6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 21:45:58 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:65343 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab1B1Cp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 21:45:57 -0500
Date: Mon, 28 Feb 2011 11:40:06 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH] memcg: clean up migration
Message-Id: <20110228114006.89177ce7.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <AANLkTik44K60MLTw_m431xd3ZFatAo=9O+42jUHscdFR@mail.gmail.com>
References: <1298821765-3167-1-git-send-email-minchan.kim@gmail.com>
	<20110228111822.41484020.nishimura@mxp.nes.nec.co.jp>
	<AANLkTik44K60MLTw_m431xd3ZFatAo=9O+42jUHscdFR@mail.gmail.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> @@ -678,13 +675,11 @@ static int unmap_and_move(new_page_t get_new_page, unsigned long private,
> >>       }
> >>
> >>       /* charge against new page */
> >> -     charge = mem_cgroup_prepare_migration(page, newpage, &mem, GFP_KERNEL);
> >> -     if (charge == -ENOMEM) {
> >> -             rc = -ENOMEM;
> >> +     rc = mem_cgroup_prepare_migration(page, newpage, &mem, GFP_KERNEL);
> >> +     if (rc)
> >>               goto unlock;
> >> -     }
> >> -     BUG_ON(charge);
> >>
> >> +     rc = -EAGAIN;
> >>       if (PageWriteback(page)) {
> >>               if (!force || !sync)
> >>                       goto uncharge;
> > How about
> >
> >        if (mem_cgroup_prepare_migration(..)) {
> >                rc = -ENOMEM;
> >                goto unlock;
> >        }
> >
> > ?
> >
> > Re-setting "rc" to -EAGAIN is not necessary in this case.
> > "if (mem_cgroup_...)" is commonly used in many places.
> >
> It works now but Johannes doesn't like it and me, either.
> It makes unnecessary dependency which mem_cgroup_preparre_migration
> can't propagate error to migrate_pages.
> Although we don't need it, I want to remove such unnecessary dependency.
> 
I see.
Thank you for your explanation.

Daisuke Nishimura.
