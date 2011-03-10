Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab1CJJwO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 04:52:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38083 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751922Ab1CJJwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 04:52:13 -0500
Date: Thu, 10 Mar 2011 01:50:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pidns: Make pid_max per namespace
Message-Id: <20110310015045.63482b62.akpm@linux-foundation.org>
In-Reply-To: <4D789B64.9000603@parallels.com>
References: <4D6F53B5.5090105@parallels.com>
	<20110307155823.22e47d73.akpm@linux-foundation.org>
	<4D789B64.9000603@parallels.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Mar 2011 12:35:32 +0300 Pavel Emelyanov <xemul@parallels.com> wrote:

> On 03/08/2011 02:58 AM, Andrew Morton wrote:
> > On Thu, 03 Mar 2011 11:39:17 +0300
> > Pavel Emelyanov <xemul@parallels.com> wrote:
> > 
> >> Rationale:
> >>
> >> On x86_64 with big ram people running containers set pid_max on host to 
> >> large values to be able to launch more containers. At the same time 
> >> containers running 32-bit software experience problems with large pids - ps
> >> calls readdir/stat on proc entries and inode's i_ino happen to be too big 
> >> for the 32-bit API.
> >>
> >> Thus, the ability to limit the pid value inside container is required.
> >>
> > 
> > This is a behavioural change, isn't it?  In current kernels a write to
> > /proc/sys/kernel/pid_max will change the max pid on all processes. 
> > After this change, that write will only affect processes in the current
> > namespace.  Anyone who was depending on the old behaviour might run
> > into problems?
> 
> Hardly. If the behavior of some two apps depends on its synchronous change,
> these two might want to run in the same pid namespace.

I don't understand your answer.  What is this "synchronous change" of which
you speak?  Does your "might want to run" suggestion mean that userspace 
changes would be required for this operation to again work correctly?


"In current kernels a write to /proc/sys/kernel/pid_max will change the
max pid on all processes."  Is this incorrect?

"After this change (ie: this patch), that write will only affect
processes in the current namespace.".  Is this incorrect?
