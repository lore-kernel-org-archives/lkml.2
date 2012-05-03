Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939Ab2ECXVe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 19:21:34 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:48001 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756385Ab2ECXVc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 19:21:32 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1205031454400.1631@chino.kir.corp.google.com>
References: <20120427161146.95422142968526faaff615d4@canb.auug.org.au>
	<4F9ABF9C.2070707@xenotime.net>
	<alpine.DEB.2.00.1204271141040.28516@chino.kir.corp.google.com>
	<20120427132343.fbb443b9.akpm@linux-foundation.org>
	<alpine.DEB.2.00.1204271420350.4631@chino.kir.corp.google.com>
	<20120427143646.8209627e.akpm@linux-foundation.org>
	<87fwbnag6u.fsf@skywalker.in.ibm.com>
	<alpine.DEB.2.00.1205030208120.21476@chino.kir.corp.google.com>
	<CABEgKgqWo=b=o7PwOLc=QqCWXQxUaYvMX99GP9cR_Y-RoTEW3g@mail.gmail.com>
	<alpine.DEB.2.00.1205031343300.1631@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1205031454400.1631@chino.kir.corp.google.com>
Date: Fri, 4 May 2012 08:21:31 +0900
Message-ID: <CABEgKgrkQ=asB2WExQb1KTd1MyoWDwJCO2_u2cJC4toEUa3C4g@mail.gmail.com>
Subject: Re: inux-next: Tree for Apr 27 (uml + mm/memcontrol.c)
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 4, 2012 at 6:57 AM, David Rientjes <rientjes@google.com> wrote:
> On Thu, 3 May 2012, David Rientjes wrote:
>
>> Is this a claim that memory-intensive workloads will have the exact same
>> performance with and without memcg enabled?
>
> I've just run specjbb2005 three times on my system both with and without
> cgroup_disable=memory on the command line and it is consistently 1% faster
> without memcg.
Hm, ok. Where is that overheads from ? Do you have perf output ?
I'll need to check what is bad.

> If I add XX:+UseLargePages to the command line to use
> hugepages it's even larger.  So why must I incur this performance
> degradation if I simply want to control who may mmap hugepages out of the
> global pool?

Is that common use case ? If he wants to do some resource control,
common users will limit usual memory, too. That kinds of too much flexibility
makes cgroup complicated, hard-to-use.

Thanks,
-Kame
