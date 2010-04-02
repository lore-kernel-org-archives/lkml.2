Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab0DBVHP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 17:07:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754185Ab0DBVHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 17:07:08 -0400
Date: Fri, 2 Apr 2010 23:04:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, anfei <anfei.zhou@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       nishimura@mxp.nes.nec.co.jp,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch -mm] oom: exclude tasks with badness score of 0 from
	being selected
Message-ID: <20100402210459.GA5112@redhat.com>
References: <20100331175836.GA11635@redhat.com> <20100331204718.GD11635@redhat.com> <alpine.DEB.2.00.1004010133190.6285@chino.kir.corp.google.com> <20100401135927.GA12460@redhat.com> <alpine.DEB.2.00.1004011210380.30661@chino.kir.corp.google.com> <20100402111406.GA4432@redhat.com> <alpine.DEB.2.00.1004021159310.1773@chino.kir.corp.google.com> <20100402191414.GA982@redhat.com> <alpine.DEB.2.00.1004021244010.15445@chino.kir.corp.google.com> <alpine.DEB.2.00.1004021253480.18402@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1004021253480.18402@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02, David Rientjes wrote:
>
> An oom_badness() score of 0 means "never kill" according to
> Documentation/filesystems/proc.txt, so explicitly exclude it from being
> selected for kill.  These tasks have either detached their p->mm or are
> set to OOM_DISABLE.

Agreed, but

> @@ -336,6 +336,8 @@ static struct task_struct *select_bad_process(unsigned int *ppoints,
>  			continue;
>
>  		points = oom_badness(p, totalpages);
> +		if (!points)
> +			continue;
>  		if (points > *ppoints || !chosen) {

then "|| !chosen" can be killed.

with this patch  !chosen <=> !*ppoints, and since points > 0

		if (points > *ppoints) {

is enough.

Oleg.

