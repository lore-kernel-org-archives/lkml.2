Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab2BELsE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 06:48:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46249 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289Ab2BELsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 06:48:02 -0500
Date: Sun, 5 Feb 2012 12:47:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/5 v2] [GIT PULL] x86/jump label: Paranoid checks and 2
 or 5 byte nops
Message-ID: <20120205114751.GA27049@elte.hu>
References: <1327936060.22710.165.camel@gandalf.stny.rr.com>
 <20120131194813.GA12074@elte.hu>
 <1328072925.5882.57.camel@gandalf.stny.rr.com>
 <20120201080539.GA11770@elte.hu>
 <1328109697.5882.65.camel@gandalf.stny.rr.com>
 <20120202135154.GA10315@elte.hu>
 <4F2A9960.2090500@zytor.com>
 <1328193068.5882.95.camel@gandalf.stny.rr.com>
 <20120203073632.GB30543@elte.hu>
 <1328275874.5882.137.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328275874.5882.137.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Fri, 2012-02-03 at 08:36 +0100, Ingo Molnar wrote:
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > Now I'm running a ktest bisect on the out-of-tree branch to 
> > > find the commit that prevents this box from booting. [...]
> > 
> > Let me know once you have found that and are able to boot -tip 
> > with your new bits applied. tip:out-of-tree needs definitely 
> > needs a cleanup - I'll probably even make it internal to my 
> > testing to not uglify tip:master.
> 
> Found it. I found this once before, but couldn't find it when I looked,
> but it was still there :-/
> 
> Anyway, here's the commit that prevents my box from booting:
> 
> commit 41e95d95208c62d4b0fbcee5f16d93e23ca32984
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Thu Sep 17 23:12:20 2009 +0200
> 
>     <not-for-merge> Disable DEVTMPFS_MOUNT for now
> 
> 
> It seems that this box requires DEVTMPFS_MOUNT to be set in 
> order to boot.

Hm, silly userspace, because the *enabling* of this option can 
break existing setups as well:

| Subject: [PATCH] <not-for-merge> Disable DEVTMPFS_MOUNT for now
|
| Causing bootup problems - /dev/zero and /dev/null not being there, etc.
|
| NOT-Signed-off-by: Ingo Molnar <mingo@elte.hu>

You could probably work it around by doing something like:

   mkdir /mnt2
   mount /dev/root /mnt2
   cp -a /dev/* /mnt2/

this will create the device nodes in /dev and make them 
available to early userspace even if it could not mount devtmpfs 
like it used to.

Thanks,

	Ingo
