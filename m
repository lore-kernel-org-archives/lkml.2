Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071Ab1JNWnx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 18:43:53 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57054 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921Ab1JNWnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 18:43:52 -0400
Date: Fri, 14 Oct 2011 15:43:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        containers@lists.linux-foundation.org, jacob.jun.pan@linux.intel.com,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Matt Helsley <matthltc@us.ibm.com>, linux-api@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>, lennart@poettering.net,
        harald@redhat.com, david@fubar.dk, greg@kroah.com
Subject: Re: [PATCH, v10 3/3] cgroups: introduce timer slack controller
Message-Id: <20111014154348.ae6267aa.akpm@linux-foundation.org>
In-Reply-To: <1318349729-3108-4-git-send-email-kirill@shutemov.name>
References: <1318349729-3108-1-git-send-email-kirill@shutemov.name>
	<1318349729-3108-4-git-send-email-kirill@shutemov.name>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Oct 2011 19:15:29 +0300
"Kirill A. Shutemov" <kirill@shutemov.name> wrote:

> Every task_struct has timer_slack_ns value. This value uses to round up
> poll() and select() timeout values. This feature can be useful in
> mobile environment where combined wakeups are desired.
> 
> Originally, prctl() was the only way to change timer slack value of
> a process. So you was not able change timer slack value of another
> process.
> 
> cgroup subsys "timer_slack" implements timer slack controller. It
> provides a way to set minimal timer slack value for a group of tasks.
> If a task belongs to a cgroup with minimal timer slack value higher than
> task's value, cgroup's value will be applied.
> 
> Timer slack controller allows to implement setting timer slack value of
> a process based on a policy. For example, you can create foreground and
> background cgroups and move tasks between them based on system state.

I'm having trouble understanding the value of this feature.  Users can
presently control the timer-slack of a group of processes via
inherit-over-fork.

Perhaps there's a case for providing a way for process A to set process
B's slack.  And perhaps B's children.  That would be a simpler patch
and would have the considerable advantage that it doesn't require
cgroups.

So.... why should we merge this?
