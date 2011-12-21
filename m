Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab1LUR7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 12:59:55 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:52836 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751595Ab1LUR7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 12:59:53 -0500
Date: Wed, 21 Dec 2011 18:59:45 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mandeep Singh Baines <msb@chromium.org>,
        Containers <containers@lists.linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Paul Menage <paul@paulmenage.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: Q: cgroup: Questions about possible issues in cgroup locking
Message-ID: <20111221175943.GG17668@somewhere>
References: <20111221034334.GD17668@somewhere>
 <20111221130848.GA19679@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111221130848.GA19679@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 02:08:48PM +0100, Oleg Nesterov wrote:
> On 12/21, Frederic Weisbecker wrote:
> > - By the time we call cgroup_post_fork(), it is ready to be woken up
> > and usable by the scheduler.
> 
> No, the new child can't run until do_fork()->wake_up_new_task().

Out of curiosity, why is it not possible for a task to kill and wake up the child
before that happens?

Understanding that could potentially let us remove the task_lock() in cgroup_post_fork()
(although I need to examine that more deeply).

Thanks!
