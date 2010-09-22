Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038Ab0IVH2y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 03:28:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:51759 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952Ab0IVH2x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 03:28:53 -0400
Subject: Re: [RFC PATCH 0/2] perf_events: add support for per-cpu
 per-cgroup monitoring (v3)
From: Peter Zijlstra <peterz@infradead.org>
To: balbir@linux.vnet.ibm.com
Cc: eranian@google.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
        perfmon2-devel@lists.sf.net, eranian@gmail.com, robert.richter@amd.com,
        acme@redhat.com, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>
In-Reply-To: <20100922042354.GG6676@balbir.in.ibm.com>
References: <4c88dc9c.991ce30a.3d91.3e0e@mx.google.com>
	 <1285061899.2275.824.camel@laptop>
	 <20100922042354.GG6676@balbir.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 22 Sep 2010 09:27:59 +0200
Message-ID: <1285140479.2275.893.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-22 at 09:53 +0530, Balbir Singh wrote:
> Yes, a task can belong to multiple subsystems, hence multiple cgroups.
> Ideally we'd want to use pid + subsystem

Apparently we create a perf subsystem, and we only care about that. So
pid will uniquely identify a cgroup, since for each subsystem a task can
only belong to one cgroup.

> > One thing we could do is pass this cgroup identifier in the pid field
> > and use PERF_FLAG_CGROUP or something. Currently the syscall signature
> > uses pid_t, but I think we can safely change that to int.
> 
> Or union it and overload the field to contain either pid_t or fd of the cgroup

Its not a field, its an argument.
