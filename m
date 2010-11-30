Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab0K3RNs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 12:13:48 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:50114 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751289Ab0K3RNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 12:13:47 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/aVSk/R4Xa8aFl+DBKodVw0N3WrseSaqrTm9TSZh
	NUGujJzzQb7RpI
Subject: Re: [PATCH v4] sched: automated per session task groups
From: Mike Galbraith <efault@gmx.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Paul Turner <pjt@google.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20101130151749.GE26758@redhat.com>
References: <20101128201851.GA20555@elte.hu>
	 <1291031593.32004.19.camel@laptop>
	 <AANLkTimQ2Kp2=um9ip7J2=-joskmz4P-0b_SrexFbTh0@mail.gmail.com>
	 <1291052268.32004.171.camel@laptop>
	 <1291057565.20709.2.camel@marge.simson.net>
	 <20101129192033.GA18372@elte.hu>
	 <AANLkTi=jra_M+F9OKj31uS6EMu+ZkPT++GSrNd_bgXSy@mail.gmail.com>
	 <1291090455.7550.7.camel@marge.simson.net>
	 <AANLkTi=YDHyRcP5NSdVDRMW0_oj1L85aLzGV9hFGw1FN@mail.gmail.com>
	 <1291123083.28239.18.camel@marge.simson.net>
	 <20101130151749.GE26758@redhat.com>
Content-Type: text/plain
Date: Tue, 30 Nov 2010 18:13:41 +0100
Message-Id: <1291137221.28239.70.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-30 at 10:17 -0500, Vivek Goyal wrote:

> Hi Mike,

Hi,

> I was wonderig if these autogroups can be visible in regular cgroup
> hierarchy so that once somebody mounts cpu controller, these are visible?

No, autogroup is not auto-cgroup.  You get zero whistles and zero bells
with autogroup.  Only dirt simple automated task groups.

> I was wondering why is a good idea to create a separate interface for
> autogroups through proc and not try to integrate it with cgroup interface.

I only put an interface there at all because it was requested, and made
it a dirt simple 'nice level' interface because there's nothing simpler
than 'nice'.  The whole autogroup thing is intended for folks who don't
want to set up cgroups, shares yadayada, so tying it into the cgroups
interface seems kinda pointless.

> Without it now any user space tool shall have to either disable the
> autogroup feature completely or now also worry about /proc interface
> and there also autogroups are searchable through pid and there is no
> direct way to access these.

Maybe I should make it disable itself when you mount big brother.

> IIUC, these autogroups create flat setup and are at same level as
> init_task_group and are not children of it. Currently cpu cgroup 
> is hierarchical by default and any new cgroup is child of init_task_group
> and that could lead to representation issues.

Well, it's flat, but autogroup does..
	tg = sched_create_group(&init_task_group);

> Well, will we not get same kind of latency boost if we make these autogroups
> children of root? If yes, then hierarchical representation issue of autogroup
> will be a moot point.

No problem then.

> We already have /proc/<pid>/cgroup interface which points to tasks's
> cgroup. We probably can avoid creating /proc/<pid>/autgroup if there
> is an associated cgroup which appears in cgroup hierachy and then user
> can change the weight of group through cgroup interface (instead of
> introducing another interface).

That's possible (for someone familiar with cgroups;), but I don't see
any reason for a wedding.

	-Mike

