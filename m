Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759622Ab2DJWyi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 18:54:38 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39868 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491Ab2DJWyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 18:54:37 -0400
Date: Wed, 11 Apr 2012 02:54:31 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Valdis.Kletnieks@vt.edu,
        Michal Marek <mmarek@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: + syscalls-x86-add-__nr_kcmp-syscall-v8.patch added to -mm tree
Message-ID: <20120410225431.GN24857@moon>
References: <20120215143606.GA14037@redhat.com>
 <20120215160652.GA17680@redhat.com>
 <20120215162752.GF4533@moon>
 <20120409151027.7f3e0fa5.akpm@linux-foundation.org>
 <m1ehrwb74t.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ehrwb74t.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2012 at 08:25:22PM -0700, Eric W. Biederman wrote:
...
> 
> Having just read through it again the only possible issue I can see is
> that we compare file descriptors after dropping all of the locks.
> 
> Since rcu_read_lock doesn't participate in ABBA deadlocks. My gut feel
> is that we should hold rcu_read_lock across the hole file pointer
> comparison to remove the possibility of races as file descriptor
> pointers go away.
> 
> Still in practice I don't think it matters.  At worst there is the
> slightest possibility of returning a value instead of -EBADF.  The
> expectation is for all of the tasks we are operating on to be frozen,
> and even if the tasks are not frozen it is a very tiny window for a race
> to be in.

yeah, we use this call heavily on stopped tasks atm

> > So what do people think?  Any issues?  Any nacks?  Should I sneak it
> > into Linus this week or do we need to go another round with it all?
> 
> Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> 

Thanks a lot, Eric!

	Cyrill
