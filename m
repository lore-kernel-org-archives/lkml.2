Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab2DNLfg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 07:35:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43587 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754918Ab2DNLff convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 07:35:35 -0400
Message-ID: <1334403322.2528.73.camel@twins>
Subject: Re: [patch 0/2] cpusets, cpu_cgroup: disallow attaching kthreadd
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Rientjes <rientjes@google.com>
Cc: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>, Tejun Heo <tj@kernel.org>,
        Mike Galbraith <mgalbraith@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Menage <paul@paulmenage.org>,
        LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>
Date: Sat, 14 Apr 2012 13:35:22 +0200
In-Reply-To: <alpine.DEB.2.00.1204091747470.4449@chino.kir.corp.google.com>
References: <20120405160829.GA12854@google.com>
	 <alpine.DEB.2.00.1204051417490.17852@chino.kir.corp.google.com>
	 <20120405213704.GA29517@google.com>
	 <alpine.DEB.2.00.1204051454070.17852@chino.kir.corp.google.com>
	 <20120405222400.GC29517@google.com>
	 <alpine.DEB.2.00.1204051542280.25838@chino.kir.corp.google.com>
	 <20120405225854.GE29517@google.com>
	 <alpine.DEB.2.00.1204051559480.25838@chino.kir.corp.google.com>
	 <20120405231306.GF29517@google.com>
	 <alpine.DEB.2.00.1204051630400.25838@chino.kir.corp.google.com>
	 <20120406155203.GA4798@dhcp-172-17-108-109.mtv.corp.google.com>
	 <1333736770.2960.114.camel@laptop>
	 <alpine.DEB.2.00.1204061347180.23328@chino.kir.corp.google.com>
	 <CABEgKgopoHYiisCQnqeFc4qT-Y4Md1b6enTcZdomoKn0vGv_RQ@mail.gmail.com>
	 <alpine.DEB.2.00.1204091747470.4449@chino.kir.corp.google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-09 at 17:52 -0700, David Rientjes wrote:
> On Sun, 8 Apr 2012, Hiroyuki Kamezawa wrote:
> 
> > I'm sorry if I didn't read e-mails while a trip....let me understand...
> > 
> >  - Tejun at el, tries to disallow to move kthreadd into cgroups other than root.
> >  - You wants to account kthreadd's activity under memg at el.
> > 
> 
> memcg isn't the only use case, you can also use it for cpuacct and any 
> other future cgroup that wants to do so.

fwiw, it would be ever so nice to get rid of cpuacct -- its a horrendous
piece of crap.

Anyway, memcg is more than an bean counter, it can do actual
enforcement, so by allowing it outside the root group you allow it into
an enforced group, making it so that you cannot spawn more threads at
some point, which might mean making your kernel not work properly.

Just fix memcg already to account whatever you want for the root group.
