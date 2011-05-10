Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab1EJXlu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 19:41:50 -0400
Received: from smtp-out.google.com ([216.239.44.51]:35167 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170Ab1EJXlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 19:41:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=UMYzsfN1os8IuXSpxDZsKrR1A3zj1ElYNwjD7PapTxm7ObiRLEI0m8j7jm0PJ5Vovj
         rpVTzb8vDYG/O0VCvmyw==
Date: Tue, 10 May 2011 16:41:44 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: CAI Qian <caiqian@redhat.com>, avagin@gmail.com,
        Andrey Vagin <avagin@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan.kim@gmail.com>, Hugh Dickins <hughd@google.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 4/4] oom: don't kill random process
In-Reply-To: <20110510171800.16B7.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1105101640560.12477@chino.kir.corp.google.com>
References: <20110509182110.167F.A69D9226@jp.fujitsu.com> <20110510171335.16A7.A69D9226@jp.fujitsu.com> <20110510171800.16B7.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 May 2011, KOSAKI Motohiro wrote:

> CAI Qian reported oom-killer killed all system daemons in his
> system at first if he ran fork bomb as root. The problem is,
> current logic give them bonus of 3% of system ram. Example,
> he has 16GB machine, then root processes have ~500MB oom
> immune. It bring us crazy bad result. _all_ processes have
> oom-score=1 and then, oom killer ignore process memroy usage
> and kill random process. This regression is caused by commit
> a63d83f427 (oom: badness heuristic rewrite).
> 
> This patch changes select_bad_process() slightly. If oom points == 1,
> it's a sign that the system have only root privileged processes or
> similar. Thus, select_bad_process() calculate oom badness without
> root bonus and select eligible process.
> 

This second (and very costly) iteration is unnecessary if the range of 
oom scores is increased from 1000 to 10000 or 100000 as suggested in the 
previous patch.
