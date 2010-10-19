Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040Ab0JSG2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 02:28:20 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58632 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab0JSG2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 02:28:19 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 19 Oct 2010 15:22:49 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Figo.zhang" <zhangtianfei@leadcoretech.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rientjes@google.com" <rientjes@google.com>,
        figo1802 <figo1802@gmail.com>
Subject: Re: oom_killer crash linux system
Message-Id: <20101019152249.e268b1e9.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1287454058.2078.12.camel@myhost>
References: <20101018021126.GB8654@localhost>
	<1287389631.1997.9.camel@myhost>
	<20101018180919.3AF8.A69D9226@jp.fujitsu.com>
	<1287454058.2078.12.camel@myhost>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Oct 2010 10:07:38 +0800
"Figo.zhang" <zhangtianfei@leadcoretech.com> wrote:

> 
> > 
> > very lots of change ;)
> > can you please send us your crash log?
> 
> i add some prink in select_bad_process() and oom_badness() to see
> pid/totalpages/points/memoryuseage/and finally process to selet to kill.
> 
> i found it the oom-killer select: syslog-ng,mysqld,nautilus,VirtualBox
> to kill, so my question is:
> 
please show your patch..for getting logs.

It seems you added printke to here.
>                 if (points > *ppoints) {
>                         chosen = p;
>                         *ppoints = points;
>                 }

So, finally _a_ chosen process is ....

> ===========have choose pid=1304 to kill, points=1

> Oct 19 09:44:08 myhost kernel: [  618.441168] oom_badness: memoy use
> =4346, totalpages=506807, points=8
...
> Oct 19 09:44:08 myhost kernel: [  618.441170] oom_badness: pid = 2065,
> oom_score_adj=0, points=8
> Oct 19 09:44:08 myhost kernel: [  618.441171] select_bad_process,
> pid=2065, points=8
> Oct 19 09:44:08 myhost kernel: [  618.441172] select_bad_process,
> ===========have choose pid=2065 to kill, points=8
...
> Oct 19 09:44:08 myhost kernel: [  618.441189] oom_badness: memoy use
> =18211, totalpages=506807, points=35
> Oct 19 09:44:08 myhost kernel: [  618.441190] oom_badness: pid = 2078,
> oom_score_adj=0, points=35
> Oct 19 09:44:08 myhost kernel: [  618.441191] select_bad_process,
> pid=2078, points=35
> Oct 19 09:44:08 myhost kernel: [  618.441193] select_bad_process,
> ===========have choose pid=2078 to kill, points=35
...
> Oct 19 09:44:08 myhost kernel: [  618.441356] oom_badness: memoy use
> =278247, totalpages=506807, points=549
> Oct 19 09:44:08 myhost kernel: [  618.441358] oom_badness: pid = 2646,
> oom_score_adj=0, points=549
> Oct 19 09:44:08 myhost kernel: [  618.441359] select_bad_process,
> pid=2646, points=549
> Oct 19 09:44:08 myhost kernel: [  618.441360] select_bad_process,
> ===========have choose pid=2646 to kill, points=549

> Oct 19 09:44:08 myhost kernel: [  618.441470] httpd invoked oom-killer:
> gfp_mask=0x201da, order=0, oom_adj=0, oom_score_adj=0
> Oct 19 09:44:08 myhost kernel: [  618.441473] httpd cpuset=/
> mems_allowed=0

PID 2646, Virtual Box. Right ?

I think you have a log message as.
==
        pr_err("Killed process %d (%s) total-vm:%lukB, anon-rss:%lukB, file-rss:%lukB\n",
                task_pid_nr(p), p->comm, K(p->mm->total_vm),
                K(get_mm_counter(p->mm, MM_ANONPAGES)),
                K(get_mm_counter(p->mm, MM_FILEPAGES)));
==
... and killed one is Virtual box.(and syslog-ng etc.. aren't killed.)

Thanks,
-Kame


