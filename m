Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab2ATPMq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 10:12:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753616Ab2ATPMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 10:12:41 -0500
Date: Fri, 20 Jan 2012 16:06:20 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Paul Menage <paul@paulmenage.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: Q: cgroup: Questions about possible issues in cgroup locking
Message-ID: <20120120150620.GB9081@redhat.com>
References: <20120111160730.GA24556@redhat.com> <20120112003102.GB9511@google.com> <20120112170728.GA25717@redhat.com> <20120112175725.GD9511@google.com> <20120113152010.GA19215@redhat.com> <20120113182750.GD18166@google.com> <20120114173648.GA32543@redhat.com> <20120118231742.GS18166@google.com> <20120119154522.GA14058@redhat.com> <20120119181803.GU18166@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120119181803.GU18166@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19, Mandeep Singh Baines wrote:
>
> Oleg Nesterov (oleg@redhat.com) wrote:
> > But we did
> > have a reason (reasons?). Hopefully, the only really important reason
> > was already removed by 087806b1.
>
> Ah. So the leader->group_leader may have been necessary earlier in order
> to prevent two tasks, old leader and new leader from both returning true
> for thread_group_leader(tsk).

Not really. de_thread() does release_task(old_leader). Please look, for
example, at __exit_signal(). thread_group_leader() must not be true in
this case.

Oleg.

