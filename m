Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221Ab0JSBVl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 21:21:41 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:52228 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755116Ab0JSBVk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 21:21:40 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: Deadlock possibly caused by too_many_isolated.
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        Neil Brown <neilb@suse.de>, Wu Fengguang <fengguang.wu@intel.com>,
        Rik van Riel <riel@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Li, Shaohua" <shaohua.li@intel.com>
In-Reply-To: <AANLkTin38qJ-U3B7XwMh-3aR9zRs21LgR1yHfqYifxrn@mail.gmail.com>
References: <20101019095144.A1B0.A69D9226@jp.fujitsu.com> <AANLkTin38qJ-U3B7XwMh-3aR9zRs21LgR1yHfqYifxrn@mail.gmail.com>
Message-Id: <20101019102114.A1B9.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 19 Oct 2010 10:21:32 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Oct 19, 2010 at 9:57 AM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> >> > I think there are two bugs here.
> >> > The raid1 bug that Torsten mentions is certainly real (and has been around
> >> > for an embarrassingly long time).
> >> > The bug that I identified in too_many_isolated is also a real bug and can be
> >> > triggered without md/raid1 in the mix.
> >> > So this is not a 'full fix' for every bug in the kernel :-), but it could
> >> > well be a full fix for this particular bug.
> >> >
> >>
> >> Can we just delete the too_many_isolated() logic?  (Crappy comment
> >> describes what the code does but not why it does it).
> >
> > if my remember is correct, we got bug report that LTP may makes misterious
> > OOM killer invocation about 1-2 years ago. because, if too many parocess are in
> > reclaim path, all of reclaimable pages can be isolated and last reclaimer found
> > the system don't have any reclaimable pages and lead to invoke OOM killer.
> > We have strong motivation to avoid false positive oom. then, some discusstion
> > made this patch.
> >
> > if my remember is incorrect, I hope Wu or Rik fix me.
> 
> AFAIR, it's right.
> 
> How about this?
> 
> It's rather aggressive throttling than old(ie, it considers not lru
> type granularity but zone )
> But I think it can prevent unnecessary OOM problem and solve deadlock problem.

Can you please elaborate your intention? Do you think Wu's approach is wrong?



