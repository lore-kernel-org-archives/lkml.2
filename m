Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab1EaDZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 23:25:19 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48228 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134Ab1EaDZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 23:25:17 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 31 May 2011 12:18:15 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Christoph Lameter <cl@linux.com>,
        Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] mm, vmstat: Use cond_resched only when !CONFIG_PREEMPT
Message-Id: <20110531121815.67523361.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <BANLkTinTqijGxCpZ_nRwWZHYsR-u2zojZA@mail.gmail.com>
References: <1306774744.4061.5.camel@localhost.localdomain>
	<20110531083859.98e4ff43.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTinTqijGxCpZ_nRwWZHYsR-u2zojZA@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 May 2011 09:13:47 +0600
Rakib Mullick <rakib.mullick@gmail.com> wrote:

> On Tue, May 31, 2011 at 5:38 AM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > On Mon, 30 May 2011 22:59:04 +0600
> > Rakib Mullick <rakib.mullick@gmail.com> wrote:
> >
> >> commit 468fd62ed9 (vmstats: add cond_resched() to refresh_cpu_vm_stats()) added cond_resched() in refresh_cpu_vm_stats. Purpose of that patch was to allow other threads to run in non-preemptive case. This patch, makes sure that cond_resched() gets called when !CONFIG_PREEMPT is set. In a preemptiable kernel we don't need to call cond_resched().
> >>
> >> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> >
> > Hmm, what benefit do we get by adding this extra #ifdef in the code directly ?
> > Other cond_resched() callers are not guilty in !CONFIG_PREEMPT ?
> >
> Well, in preemptible kernel this context will get preempted if
> requires, so we don't need cond_resched(). If you checkout the git log
> of the mentioned commit, you'll find the explanation. It says:
>         "Adding a cond_resched() to allow other threads to run in the
> non-preemptive
>     case."
> 

IOW, my question is "why only this cond_resched() should be fixed ?"
What's bad with all cond_resched() in the kernel as no-op in CONFIG_PREEMPT ?

Thanks,
-Kame


