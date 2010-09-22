Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547Ab0IVJSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 05:18:44 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:53943 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797Ab0IVJSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 05:18:43 -0400
Date: Wed, 22 Sep 2010 14:48:34 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: eranian@google.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
        perfmon2-devel@lists.sf.net, eranian@gmail.com, robert.richter@amd.com,
        acme@redhat.com, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [RFC PATCH 0/2] perf_events: add support for per-cpu per-cgroup
 monitoring (v3)
Message-ID: <20100922091834.GJ6676@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <4c88dc9c.991ce30a.3d91.3e0e@mx.google.com>
 <1285061899.2275.824.camel@laptop>
 <20100922042354.GG6676@balbir.in.ibm.com>
 <1285140479.2275.893.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1285140479.2275.893.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2010-09-22 09:27:59]:

> On Wed, 2010-09-22 at 09:53 +0530, Balbir Singh wrote:
> > Yes, a task can belong to multiple subsystems, hence multiple cgroups.
> > Ideally we'd want to use pid + subsystem
> 
> Apparently we create a perf subsystem, and we only care about that. So
> pid will uniquely identify a cgroup, since for each subsystem a task can
> only belong to one cgroup.

Hmm.. I misread the intention to mean we care about monitoring all
data and aggregate it for each cgroup.

> 
> > > One thing we could do is pass this cgroup identifier in the pid field
> > > and use PERF_FLAG_CGROUP or something. Currently the syscall signature
> > > uses pid_t, but I think we can safely change that to int.
> > 
> > Or union it and overload the field to contain either pid_t or fd of the cgroup
> 
> Its not a field, its an argument.

Thanks!

-- 
	Three Cheers,
	Balbir
