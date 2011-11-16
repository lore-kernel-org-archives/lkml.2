Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab1KPXtv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 18:49:51 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59637 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862Ab1KPXtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 18:49:49 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 17 Nov 2011 08:48:14 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Luis Henriques <henrix@camandro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
        Yong Zhang <yong.zhang0@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH -rt] memcg: use migrate_disable()/migrate_enable( ) in
 memcg_check_events()
Message-Id: <20111117084814.0e6b8169.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111116171809.GA1999@hades>
References: <alpine.LFD.2.02.1111150050590.4902@ionos>
	<20111115084059.GA23250@zhy>
	<20111116091653.GA8692@zhy>
	<1321452758.4181.18.camel@frodo>
	<alpine.LFD.2.02.1111161801270.4902@ionos>
	<20111116171809.GA1999@hades>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Nov 2011 17:18:09 +0000
Luis Henriques <henrix@camandro.org> wrote:

> On Wed, Nov 16, 2011 at 06:02:42PM +0100, Thomas Gleixner wrote:
> > On Wed, 16 Nov 2011, Steven Rostedt wrote:
> > > On Wed, 2011-11-16 at 17:16 +0800, Yong Zhang wrote:
> > > > Looking at commit 4799401f [memcg: Fix race condition in
> > > > memcg_check_events() with this_cpu usage], we just want
> > > > to disable migration. So use the right API in -rt. This
> > > > will cure below warning.
> > > No this won't work. Not even for -rt. If we disable migration but not
> > > preemption, then two tasks can take this path. And the checks in
> > > __memcg_event_check() will be corrupted because nothing is protecting
> > > the updates from two tasks going into the same path.
> > > 
> > > Perhaps a local_lock would work.
> > 
> > Yes, that's the only sensible option for now. Untested patch below.
> 
> I run a quick test and it looks like the problem is gone.
> 
> Cheers,

Could you CC the final patch to cgroups@vger.kernel.org ?
Does this fix will go thorugh rt tree rather than -mm ?

Thanks,
-Kame

