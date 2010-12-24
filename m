Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869Ab0LXQs3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 11:48:29 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:35538 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752404Ab0LXQs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 11:48:27 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+WloRbTMOW7kjTXjF94DkgM5xLuWyJiD7PXOsXzv
	+lFQmwjyt1M6a5
Subject: Re: [PATCH] sched, cgroup: Use exit hook to avoid use-after-free
 crash
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Miklos Vajna <vmiklos@frugalware.org>,
        shenghui <crosslonelyover@gmail.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@elte.hu, Greg KH <greg@kroah.com>,
        Paul Turner <pjt@google.com>, Yong Zhang <yong.zhang0@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>
In-Reply-To: <1293206353.29444.205.camel@laptop>
References: <AANLkTin49UHeVhfS-iFwWvPIg29HPhXaP3DorBAa-a0I@mail.gmail.com>
	 <1277808215.1868.5.camel@laptop>
	 <20101219020313.GJ31750@genesis.frugalware.org>
	 <20101222002248.GP10557@genesis.frugalware.org>
	 <1293006589.2170.41.camel@laptop>
	 <1293007311.11370.172.camel@marge.simson.net>
	 <1293008842.2170.70.camel@laptop>
	 <20101222133154.GS10557@genesis.frugalware.org>
	 <1293026422.2170.136.camel@laptop> <1293027112.2170.140.camel@laptop>
	 <20101222151434.GW10557@genesis.frugalware.org>
	 <1293037718.2170.155.camel@laptop> <1293050173.2170.389.camel@laptop>
	 <AANLkTi=1GMKF4emms0Qpx31=xk-FZXOTaeONmCohzWb2@mail.gmail.com>
	 <1293106330.2170.618.camel@laptop>  <1293107624.2170.642.camel@laptop>
	 <1293128670.2170.748.camel@laptop>
	 <1293132304.6798.6.camel@marge.simson.net>
	 <1293132862.25981.22.camel@laptop>
	 <1293187425.7138.2.camel@marge.simson.net>
	 <1293188091.25981.200.camel@laptop>
	 <1293192999.18035.4.camel@marge.simson.net>
	 <1293206353.29444.205.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Dec 2010 17:48:17 +0100
Message-ID: <1293209297.14433.4.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-24 at 16:59 +0100, Peter Zijlstra wrote:

> So cgroup moves a task without calling cgroup_subsys::attach() which is
> odd, but it does have an ::exit method, sadly it calls that _before_
> re-assigning the task, which means we have to jump through some hoops.

Could you do the move in cgroup_exit() in the CONFIG_PREEMPT case?

	-Mike


