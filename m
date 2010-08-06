Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933916Ab0HFHNy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 03:13:54 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47126 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758900Ab0HFHNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 03:13:53 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 6 Aug 2010 16:08:27 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Ben Blum <bblum@andrew.cmu.edu>
Cc: Paul Menage <menage@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        ebiederm@xmission.com, lizf@cn.fujitsu.com, matthltc@us.ibm.com,
        oleg@redhat.com
Subject: Re: [PATCH v4 1/2] cgroups: read-write lock CLONE_THREAD forking
 per threadgroup
Message-Id: <20100806160827.d73ae050.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100806060224.GA1351@ghc17.ghc.andrew.cmu.edu>
References: <20100730235649.GA22644@ghc17.ghc.andrew.cmu.edu>
	<20100730235754.GB22644@ghc17.ghc.andrew.cmu.edu>
	<AANLkTikpNG2Y3S3AyxAbCkMynKu1u5yKPrw=bh+uy=9R@mail.gmail.com>
	<20100804043328.GB11950@ghc17.ghc.andrew.cmu.edu>
	<AANLkTi=dhym3c+XJVjoObROcw=mz2Y+a2R5oMdePK3Ng@mail.gmail.com>
	<20100806060224.GA1351@ghc17.ghc.andrew.cmu.edu>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Aug 2010 02:02:24 -0400
Ben Blum <bblum@andrew.cmu.edu> wrote:

> On Tue, Aug 03, 2010 at 09:34:22PM -0700, Paul Menage wrote:
> > On Tue, Aug 3, 2010 at 9:33 PM, Ben Blum <bblum@andrew.cmu.edu> wrote:
> > >> As far as the #ifdef mess goes, it's true that some people don't have
> > >> CONFIG_CGROUPS defined. I'd imagine that these are likely to be
> > >> embedded systems with a fairly small number of processes and threads
> > >> per process. Are there really any such platforms where the cost of a
> > >> single extra rwsem per process is going to make a difference either in
> > >> terms of memory or lock contention? I think you should consider making
> > >> these additions unconditional.
> > >
> > > That's certainly an option, but I think it would be clean enough to put
> > > static inline functions just under the signal_struct definition.
> > 
> > Either sounds fine to me. I suspect others have a stronger opinion.
> > 
> > Paul
> > 
> 
> Any other votes? One set of static inline functions (I'd call them
> threadgroup_fork_{read,write}_{un,}lock) or just remove the ifdefs
> entirely? I'm inclined to go with the former.
> 

I vote for the former. #ifdef can be easily removed if someone finds it useful
for other purpose...and static inline function is usual way.

Thanks,
-Kame

