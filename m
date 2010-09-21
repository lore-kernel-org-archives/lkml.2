Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab0IUODp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 10:03:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41120 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab0IUODo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 10:03:44 -0400
Subject: Re: [RFC PATCH 0/2] perf_events: add support for per-cpu
 per-cgroup monitoring (v3)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, robert.richter@amd.com, acme@redhat.com,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <AANLkTinmHGtLFRa4O5DNRGgoRtM4cy65JgCw=sYxEjNF@mail.gmail.com>
References: <4c88dc9c.991ce30a.3d91.3e0e@mx.google.com>
	 <1285061899.2275.824.camel@laptop> <1285062228.2275.826.camel@laptop>
	 <AANLkTik-oMNJdakwsH=22LzgYvgd35aom+Zu2WkchUte@mail.gmail.com>
	 <1285072975.2275.872.camel@laptop>
	 <AANLkTinmHGtLFRa4O5DNRGgoRtM4cy65JgCw=sYxEjNF@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 21 Sep 2010 16:03:21 +0200
Message-ID: <1285077801.2275.881.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-21 at 15:38 +0200, Stephane Eranian wrote:
> > Hmm, indeed. One thing we can do about that is move perf into the
> > cgroup, create the counter (disabled) using self to identify the cgroup,
> > move perf back to where it came from, and enable the counter.
> >
> Yes, that's another possibility. I wonder if there are any non-obvious
> difficulties with this approach.

Yes, there is, but I think we can fix it. The problem with moving perf
itself around is that perf is not a fully dormant process and can thus
interact with the cgroup state.

If we were to fork a child that's simply sitting idle in waitpid() (or
any other blocking syscall) we can move that around cgroup without
affecting the cgroup itself.

>  Is it as simple as:
>    FILE *fp;
>    fp = fopen("/dev/cgroup/test/tasks", "w");
>    fprintf(fp, "%d", gettid());
>    close(fp): 

Except I've never in my life mounted a cgroup filesystem in /dev/ :-)
