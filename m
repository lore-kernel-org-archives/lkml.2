Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932519Ab1COTbb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 15:31:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6126 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932481Ab1COTba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 15:31:30 -0400
Date: Tue, 15 Mar 2011 20:21:45 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrey Vagin <avagin@openvz.org>,
        Frantisek Hrbata <fhrbata@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3 for 2.6.38] oom: oom_kill_process: fix the
	child_points logic
Message-ID: <20110315192145.GC21640@redhat.com>
References: <alpine.DEB.2.00.1103081549530.27910@chino.kir.corp.google.com> <20110309151946.dea51cde.akpm@linux-foundation.org> <alpine.DEB.2.00.1103111142260.30699@chino.kir.corp.google.com> <20110312123413.GA18351@redhat.com> <20110312134341.GA27275@redhat.com> <AANLkTinHGSb2_jfkwx=Wjv96phzPCjBROfCTFCKi4Wey@mail.gmail.com> <20110313212726.GA24530@redhat.com> <20110314190419.GA21845@redhat.com> <20110314190530.GD21845@redhat.com> <alpine.DEB.2.00.1103141334470.31514@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1103141334470.31514@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14, David Rientjes wrote:
>
> On Mon, 14 Mar 2011, Oleg Nesterov wrote:
>
> > oom_kill_process() starts with victim_points == 0. This means that
> > (most likely) any child has more points and can be killed erroneously.
> >
> > Also, "children has a different mm" doesn't match the reality, we
> > should check child->mm != t->mm. This check is not exactly correct
> > if t->mm == NULL but this doesn't really matter, oom_kill_task()
> > will kill them anyway.
> >
> > Note: "Kill all processes sharing p->mm" in oom_kill_task() is wrong
> > too.
> >
>
> There're two issues you're addressing in this patch.  It only kills a 
> child in place of its selected parent when:
>
>  - the child has a higher badness score, and
>
>  - it has a different ->mm.
>
> In the former case, NACK, we always want to sacrifice children regardless
> of their badness score (as long as it is non-zero) if it has a separate
> ->mm in place of its parent,

Ah. So this was intentional?

OK. I was hypnotized by the security implications, and this looked so
"obviously wrong" to me.

But, of course I can't judge when it comes to oom's heuristic, and you
certainly know better.

So, thanks for correcting me.


Just a question... what about oom_kill_allocating_task? Probably
Documentation/sysctl/vm.txt should be updated.

Oleg.

