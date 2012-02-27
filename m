Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab2B0S5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 13:57:31 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37821 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab2B0S5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 13:57:30 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of fweisbec@gmail.com designates 10.52.93.77 as permitted sender) smtp.mail=fweisbec@gmail.com; dkim=pass header.i=fweisbec@gmail.com
Date: Mon, 27 Feb 2012 19:57:25 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mandeep Singh Baines <msb@chromium.org>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] cgroup: Walk task list under tasklist_lock in
 cgroup_enable_task_cg_list
Message-ID: <20120227185722.GD30232@somewhere.redhat.com>
References: <1328668647-24125-1-git-send-email-fweisbec@gmail.com>
 <1328668647-24125-3-git-send-email-fweisbec@gmail.com>
 <20120221222343.GU3090@google.com>
 <20120222005525.GC13403@somewhere.redhat.com>
 <20120222011934.GX2375@linux.vnet.ibm.com>
 <20120222013339.GG13403@somewhere.redhat.com>
 <20120222180327.GA11044@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120222180327.GA11044@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 07:03:27PM +0100, Oleg Nesterov wrote:
> Hi.
> 
> Sorry, currently I do not have the time to even read this discussion,
> just one note,
> 
> On 02/22, Frederic Weisbecker wrote:
> >
> > On Tue, Feb 21, 2012 at 05:19:34PM -0800, Paul E. McKenney wrote:
> > > On Wed, Feb 22, 2012 at 01:55:28AM +0100, Frederic Weisbecker wrote:
> > > > On Tue, Feb 21, 2012 at 02:23:43PM -0800, Mandeep Singh Baines wrote:
> > > > > Frederic Weisbecker (fweisbec@gmail.com) wrote:
> > > > > > Walking through the tasklist in cgroup_enable_task_cg_list() inside
> > > > > > an RCU read side critical section is not enough because:
> > > > > >
> > > > > > - RCU is not (yet) safe against while_each_thread()
> 
> Yes. Except I'd say it is while_each_thread() who is not safe ;)

Right.

> 
> Please do not take this into account. This should be fixed, I hope
> to send the fix "soon".

Sure, but anyway we need the read_lock here for ordering/commiting reasons.
