Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757081Ab1JNXet (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 19:34:49 -0400
Received: from shutemov.name ([188.40.19.243]:36391 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754319Ab1JNXeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 19:34:46 -0400
Date: Sat, 15 Oct 2011 02:34:45 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        containers@lists.linux-foundation.org, jacob.jun.pan@linux.intel.com,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Matt Helsley <matthltc@us.ibm.com>, linux-api@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>, lennart@poettering.net,
        harald@redhat.com, david@fubar.dk, greg@kroah.com
Subject: Re: [PATCH, v10 3/3] cgroups: introduce timer slack controller
Message-ID: <20111014233445.GA28092@shutemov.name>
References: <1318349729-3108-1-git-send-email-kirill@shutemov.name>
 <1318349729-3108-4-git-send-email-kirill@shutemov.name>
 <20111014154348.ae6267aa.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111014154348.ae6267aa.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 03:43:48PM -0700, Andrew Morton wrote:
> On Tue, 11 Oct 2011 19:15:29 +0300
> "Kirill A. Shutemov" <kirill@shutemov.name> wrote:
> 
> > Every task_struct has timer_slack_ns value. This value uses to round up
> > poll() and select() timeout values. This feature can be useful in
> > mobile environment where combined wakeups are desired.
> > 
> > Originally, prctl() was the only way to change timer slack value of
> > a process. So you was not able change timer slack value of another
> > process.
> > 
> > cgroup subsys "timer_slack" implements timer slack controller. It
> > provides a way to set minimal timer slack value for a group of tasks.
> > If a task belongs to a cgroup with minimal timer slack value higher than
> > task's value, cgroup's value will be applied.
> > 
> > Timer slack controller allows to implement setting timer slack value of
> > a process based on a policy. For example, you can create foreground and
> > background cgroups and move tasks between them based on system state.
> 
> I'm having trouble understanding the value of this feature.  Users can
> presently control the timer-slack of a group of processes via
> inherit-over-fork.
> 
> Perhaps there's a case for providing a way for process A to set process
> B's slack.  And perhaps B's children.  That would be a simpler patch
> and would have the considerable advantage that it doesn't require
> cgroups.
> 
> So.... why should we merge this?

Putting a task to a cgroup isn't change task's timer slack, it may affect
"effective timer slack", if min timer slack for the cgroup > task's timer
slack.

Since we don't touch task's slack value we can drag tasks between cgroups
and always get the most relaxed slack value for a task without
saving/restoring it in userspace.

-- 
 Kirill A. Shutemov
