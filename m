Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933019Ab0CaJUE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 05:20:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932976Ab0CaJUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 05:20:00 -0400
Date: Wed, 31 Mar 2010 11:17:40 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, anfei <anfei.zhou@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       nishimura@mxp.nes.nec.co.jp,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] proc: don't take ->siglock for /proc/pid/oom_adj
Message-ID: <20100331091740.GB11438@redhat.com>
References: <20100326150805.f5853d1c.akpm@linux-foundation.org> <20100326223356.GA20833@redhat.com> <20100328145528.GA14622@desktop> <20100328162821.GA16765@redhat.com> <alpine.DEB.2.00.1003281341590.30570@chino.kir.corp.google.com> <20100329112111.GA16971@redhat.com> <alpine.DEB.2.00.1003291302170.14859@chino.kir.corp.google.com> <20100330163909.GA16884@redhat.com> <20100330174337.GA21663@redhat.com> <alpine.DEB.2.00.1003301329420.5234@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1003301329420.5234@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30, David Rientjes wrote:
>
> On Tue, 30 Mar 2010, Oleg Nesterov wrote:
>
> > ->siglock is no longer needed to access task->signal, change
> > oom_adjust_read() and oom_adjust_write() to read/write oom_adj
> > lockless.
> >
> > Yes, this means that "echo 2 >oom_adj" and "echo 1 >oom_adj"
> > can race and the second write can win, but I hope this is OK.
> >
>
> Ok, but could you base this on -mm at
> http://userweb.kernel.org/~akpm/mmotm/ since an additional tunable has
> been added (oom_score_adj), which does the same thing?

Ah, OK, will do.

Thanks David.

Oleg.

