Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514Ab0IYJvx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 05:51:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58154 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425Ab0IYJvw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 05:51:52 -0400
Subject: Re: [RFC PATCH 0/2] perf_events: add support for per-cpu
 per-cgroup monitoring (v3)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
        perfmon2-devel@lists.sf.net, eranian@gmail.com, robert.richter@amd.com,
        acme@redhat.com, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>
In-Reply-To: <AANLkTinMsY3KcL7v9R_uwSzVcMVYvsnXHMrbG6Z9XeL4@mail.gmail.com>
References: <4c88dc9c.991ce30a.3d91.3e0e@mx.google.com>
	 <1285061899.2275.824.camel@laptop>
	 <20100922042354.GG6676@balbir.in.ibm.com>
	 <1285140479.2275.893.camel@laptop>
	 <20100922091834.GJ6676@balbir.in.ibm.com>
	 <AANLkTinMsY3KcL7v9R_uwSzVcMVYvsnXHMrbG6Z9XeL4@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 25 Sep 2010 11:51:27 +0200
Message-ID: <1285408287.2275.1061.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-22 at 12:26 +0200, Stephane Eranian wrote:

> Ok, early testing shows that this seems to be working fine with the
> pid approach. Of course it is less convenient than just opening a file
> descriptor in cgroup_fs. There is more bookkeeping involved, incl.
> cleanup the child on exit.

Right, so another approach, similar to what you initially proposed,
would be to have this cgroup file, but instead of simply opening and
passing the fd around, have it provide a cgroup id and pass that around
as an integer (or pid_t) in the task argument to the SYSCALL (see the
flag bit below).

You can use the regular lib/idr.c bits to generate ids and maintain an
id->cgroup map.

> The other thing is related to how to indicate we want cgroup and not per-thread.
> For now, my patch is using a new attr.cgroup bit. The alternative is to use a
> bit in the flags parameter to the syscall. 

Right, I prefer a bit in the syscall flags argument and somehow using
the task argument.
